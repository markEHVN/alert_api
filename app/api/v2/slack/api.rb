module V2
  module Slack
    class API < Grape::API
      namespace :slack do
        resource :statuses do
          desc "Return a public timeline."
          get :public_timeline do
            # Status.limit(20)
            "Hello, Slack V2!"
          end
        end
      end
    end
  end
end
