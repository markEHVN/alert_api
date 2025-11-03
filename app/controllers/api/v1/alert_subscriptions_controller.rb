# app/controllers/api/v1/alert_subscriptions_controller.rb
module Api
  module V1
    class AlertSubscriptionsController < ApplicationController
      before_action :find_alert
      before_action :find_subscription, only: [ :destroy ]

      # GET /api/v1/alerts/:alert_id/subscriptions
      def index
        subscriptions = @alert.alert_subscriptions
        render json: {
          data: subscriptions.map do |subscription|
            {
              id: subscription.id,
              notification_method: subscription.notification_method,
              is_active: subscription.is_active
            }
          end
        }
      end

      # POST /api/v1/alerts/:alert_id/subscriptions
      def create
        subscription = @alert.alert_subscriptions.build(subscription_params)
        subscription.user = current_user

        if subscription.save
          render json: {
            data: subscription,
            message: "Successfully subscribed to alert"
          }, status: :created
        else
          render json: {
            errors: subscription.errors
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/alerts/:alert_id/subscriptions/:id
      def destroy
        # TODO: Unsubscribe from alert
        @subscription.update!(is_active: false)

        render json: {
          message: "Successfully unsubscribed from alert"
        }
      end

      private

      def find_alert
        # TODO: Find alert
        @alert = current_user.alerts.find(params[:alert_id])
      end

      def subscription_params
        params.require(:alert_subscription).permit(:notification_method)
      end

      def find_subscription
        @subscription = @alert.alert_subscriptions.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {
          errors: [ { message: "Subscription not found" } ]
        }, status: :not_found
      end
    end
  end
end
