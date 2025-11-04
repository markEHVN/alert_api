module Api
  module V1
    class AlertsController < ApplicationController
      # This controller inherits all the security and error handling from ApplicationController

      before_action :find_alert, only: [ :show, :update, :destroy, :acknowledge, :resolve ]
      # Before running show, update, destroy, acknowledge, or resolve, find the specific alert first

      rescue_from AlertService::InvalidSeverityError, with: :handle_bad_severity
      rescue_from AlertService::NotificationFailedError, with: :handle_notification_error

      # GET /api/v1/alerts - Show all alerts for the current user
      def index
        # Get all alerts that belong to the logged-in user
        puts params
        include_parts = params[:include].to_s.split(",").map(&:strip)

        # alerts = current_user.alerts
        alerts = Alert.all
        alerts = alerts.by_severity(params[:severity]) if params[:severity].present?
        alerts = alerts.by_category(params[:category]) if params[:category].present?
        alerts = alerts.unread if params[:unread] == "true"

        # Handle includes vs preload for performance comparison
        if include_parts.include?("user")
          alerts = alerts.includes(:user)
        end

        if include_parts.include?("subscribers")
          # Compare includes vs preload behavior
          # Use preload to avoid N+1 but don't affect WHERE clauses
          if params[:load_strategy] == "preload"
            Rails.logger.info("[ALERT_API] Using preload(:alert_subscriptions, :user) strategy")
            alerts = alerts.preload(:alert_subscriptions, :user)
          else
            Rails.logger.info("[ALERT_API] Using includes(:alert_subscriptions, :user) strategy")
            alerts = alerts.includes(:alert_subscriptions, :user)
          end
        end

        alerts = alerts
        .recent
        .page(params[:page])
        .per(params[:per_page] || 20)

        # Convert alerts to JSON and send back
        serializer_options = {}
        serializer_options[:include_subscribers] = true if include_parts.include?("subscribers")

        render json: {
          data: AlertSerializer.new(alerts, serializer_options).serializable_hash[:data],
          meta: {
            current_page: alerts.current_page,
            per_page: alerts.limit_value,
            total_pages: alerts.total_pages,
            total_count: alerts.total_count,
            load_strategy: params[:load_strategy] || "includes"
          }
        }
      end

      # GET /api/v1/alerts/123 - Show one specific alert
      def show
        render json: {
          data: AlertSerializer.new(@alert).serializable_hash[:data]
        }
      end

      # POST /api/v1/alerts - Create a new alert
      def create
        service = AlertService::Create.call(
          params: alert_params,
          current_user: current_user
        )
        if service.success?
          render json: {
            data: AlertSerializer.new(service.result).serializable_hash[:data]
          }, status: :created
        else
          render json: {
            errors: service.errors
          }, status: :unprocessable_content
        end
      end

      # PATCH /api/v1/alerts/123 - Update an existing alert
      def update
        if @alert.update(alert_params)
          # Success! Send back the updated alert
          render json: {
            data: AlertSerializer.new(@alert).serializable_hash[:data]
          }
        else
          # Failed! Send back the errors
          render json: {
            errors: @alert.errors.full_messages
          }, status: :unprocessable_content
        end
      end

      # DELETE /api/v1/alerts/123 - Delete an alert
      def destroy
        @alert.destroy
        # Send back empty response with status 204 (No Content)
        head 204
      end

      # PATCH /api/v1/alerts/123/acknowledge - Acknowledge an alert
      def acknowledge
        @alert.acknowledge!(current_user)
        render json: {
          data: AlertSerializer.new(@alert.reload).serializable_hash[:data]
        }
      end

      # PATCH /api/v1/alerts/123/resolve - Resolve an alert
      def resolve
        @alert.resolve!(current_user)
        render json: {
          data: AlertSerializer.new(@alert.reload).serializable_hash[:data]
        }
      end

      private

      # This method finds a specific alert before show/update/destroy actions
      def find_alert
        # Find alert by ID, but only if it belongs to the current user (security!)
        @alert = current_user.alerts.find(params[:id])
        # If alert doesn't exist or doesn't belong to user, Rails raises RecordNotFound
        # which our ApplicationController catches and sends a 404 error
      end

      # Strong Parameters - this is Rails' way of preventing hackers
      def alert_params
        # Only allow these specific fields to be set
        # This prevents users from setting fields they shouldn't (like user_id)
        params.require(:alert).permit(:title, :message, :severity, :category)
      end

      def handle_bad_severity
        render json: {
          error: "Raise: Severity must be low, medium, high, or critical"
        }, status: :unprocessable_content
      end

      def handle_notification_error
        render json: {
          error: "Raise: Failed to send notification"
        }, status: :unprocessable_content
      end
    end
  end
end
