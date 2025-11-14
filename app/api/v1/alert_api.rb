module V1
  class AlertAPI < ApplicationAPI
    helpers do
      def find_alert!
        @alert = find_record!(::Alert, params[:id], scope: current_user.alerts)
      end
    end

    namespace :alerts do
      desc "Get all alerts for the current user"
      params do
        optional :load_strategy, type: String, desc: "Loading strategy for associations"
        optional :page, type: Integer, desc: "Page number for pagination"
        optional :per_page, type: Integer, desc: "Number of items per page"
      end
      get do
        # authenticate!
        # authorize_class!("Alert", :index)

        service = AlertService::Index.call(params: params)
        if service.success?
          alerts, serializer_options = service.result.values_at(:alerts, :serializer_options)
          {
            data: AlertSerializer.new(alerts, serializer_options).serializable_hash[:data],
            meta: {
              current_page: alerts.current_page,
              per_page: alerts.limit_value,
              total_pages: alerts.total_pages,
              total_count: alerts.total_count,
              load_strategy: params[:load_strategy] || "includes"
            }
          }
        else
          error!(service.errors, 422)
        end
      end

      # GET /api/v1/alerts/:id - Show one specific alert
      desc "Get a specific alert by ID"
      params do
        requires :id, type: Integer, desc: "Alert ID"
      end
      get ":id" do
        authenticate!
        find_alert!

        {
          data: AlertSerializer.new(@alert).serializable_hash[:data]
        }
      end

      # POST /api/v1/alerts - Create a new alert
      desc "Create a new alert"
      params do
        requires :alert, type: Hash do
          requires :title, type: String, desc: "Alert title"
          requires :message, type: String, desc: "Alert message"
          requires :severity, type: String, desc: "Alert severity"
          requires :category, type: String, desc: "Alert category"
        end
      end
      post do
        authenticate!

        service = AlertService::Create.call(
          params: declared(params)[:alert],
          current_user: current_user
        )
        if service.success?
          status 201
          {
            data: AlertSerializer.new(service.result).serializable_hash[:data]
          }
        else
          error!(service.errors, 422)
        end
      end

      # PATCH /api/v1/alerts/:id - Update an existing alert
      desc "Update an existing alert"
      params do
        requires :id, type: Integer, desc: "Alert ID"
        requires :alert, type: Hash do
          optional :title, type: String, desc: "Alert title"
          optional :message, type: String, desc: "Alert message"
          optional :severity, type: String, desc: "Alert severity"
          optional :category, type: String, desc: "Alert category"
        end
      end
      patch ":id" do
        authenticate!
        find_alert!

        service = AlertService::Update.call(alert: @alert, params: declared(params)[:alert])

        if service.success?
          {
            data: AlertSerializer.new(service.result).serializable_hash[:data]
          }
        else
          error!(service.errors, 422)
        end
      end

      # DELETE /api/v1/alerts/:id - Delete an alert
      desc "Delete an alert"
      params do
        requires :id, type: Integer, desc: "Alert ID"
      end
      delete ":id" do
        authenticate!
        find_alert!
        authorize!(@alert, :destroy)

        @alert.destroy
        # Send back empty response with status 204 (No Content)
        status 204
        body false
      end

      # PATCH /api/v1/alerts/:id/acknowledge - Acknowledge an alert
      desc "Acknowledge an alert"
      params do
        requires :id, type: Integer, desc: "Alert ID"
      end
      patch ":id/acknowledge" do
        authenticate!
        find_alert!

        service = AlertService::Acknowledge.call(alert: @alert, current_user: current_user)

        if service.success?
          {
            data: AlertSerializer.new(service.result.reload).serializable_hash[:data]
          }
        else
          error!(service.errors, 422)
        end
      end

      # PATCH /api/v1/alerts/:id/resolve - Resolve an alert
      desc "Resolve an alert"
      params do
        requires :id, type: Integer, desc: "Alert ID"
      end
      patch ":id/resolve" do
        authenticate!
        find_alert!

        service = AlertService::Resolve.call(alert: @alert, current_user: current_user)

        if service.success?
          {
            data: AlertSerializer.new(service.result.reload).serializable_hash[:data]
          }
        else
          error!(service.errors, 422)
        end
      end
    end
  end
end
