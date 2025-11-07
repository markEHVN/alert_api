module V1
  module AlertSubscription
    class API < ApplicationAPI
      # Explicitly include shared helpers to ensure they're available
      helpers ApplicationAPI::SharedHelpers

      helpers do
        def find_alert!
          @alert = find_record!(::Alert, params[:alert_id])
        end

        def find_subscription!
          @subscription = find_record!(
            ::AlertSubscription,
            params[:id],
            scope: @alert.alert_subscriptions
          )
        end
      end

      namespace :alerts do
        route_param :alert_id do
          namespace :subscriptions do
            # GET /api/v1/alerts/:alert_id/subscriptions
            desc "Get all subscriptions for an alert"
            params do
              requires :alert_id, type: Integer, desc: "Alert ID"
            end
            get do
              authenticate!
              find_alert!

              subscriptions = @alert.alert_subscriptions
              {
                data: AlertSubscriptionSerializer.new(subscriptions).serializable_hash[:data]
              }
            end

            # POST /api/v1/alerts/:alert_id/subscriptions
            desc "Create a new subscription for an alert"
            params do
              requires :alert_id, type: Integer, desc: "Alert ID"
              requires :alert_subscription, type: Hash do
                requires :notification_method, type: String, desc: "Notification method"
              end
            end
            post do
              authenticate!
              find_alert!

              subscription_params = declared(params)[:alert_subscription]
              subscription = @alert.alert_subscriptions.build(subscription_params)
              subscription.user = current_user

              if subscription.save
                status 201
                {
                  data: AlertSubscriptionSerializer.new(subscription).serializable_hash[:data],
                  message: "Successfully subscribed to alert"
                }
              else
                error!(subscription.errors.full_messages, 422)
              end
            end

            # DELETE /api/v1/alerts/:alert_id/subscriptions/:id
            desc "Unsubscribe from an alert"
            params do
              requires :alert_id, type: Integer, desc: "Alert ID"
              requires :id, type: Integer, desc: "Subscription ID"
            end
            delete ":id" do
              authenticate!
              find_alert!
              find_subscription!

              # TODO: Unsubscribe from alert
              @subscription.update!(is_active: false)

              {
                message: "Successfully unsubscribed from alert"
              }
            end
          end
        end
      end
    end
  end
end
