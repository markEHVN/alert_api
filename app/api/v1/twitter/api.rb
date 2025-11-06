module V1
  module Twitter
    class API < ApplicationAPI
      # Explicitly include shared helpers to ensure they're available
      helpers ApplicationAPI::SharedHelpers

      namespace :twitter do
        resource :statuses do
          desc "Return a public timeline."
          get :public_timeline do
            # Status.limit(20)
            "Hello, Twitter"
          end

          desc "Return a personal timeline."
          get :home_timeline do
            authenticate!
            current_user.statuses.limit(20)
          end

          desc "Return a status."
          params do
            requires :id, type: Integer, desc: "Status ID."
          end
          route_param :id do
            get do
              Status.find(params[:id])
            end
          end

          desc "Create a status."
          params do
            requires :status, type: String, desc: "Your status."
          end
          post do
            authenticate!
            Status.create!({
              user: current_user,
              text: params[:status]
            })
          end

          desc "Update a status."
          params do
            requires :id, type: String, desc: "Status ID."
            requires :status, type: String, desc: "Your status."
          end
          put ":id" do
            authenticate!
            current_user.statuses.find(params[:id]).update({
              user: current_user,
              text: params[:status]
            })
          end

          desc "Delete a status."
          params do
            requires :id, type: String, desc: "Status ID."
          end
          delete ":id" do
            authenticate!
            current_user.statuses.find(params[:id]).destroy
          end
        end
      end
    end
  end
end
