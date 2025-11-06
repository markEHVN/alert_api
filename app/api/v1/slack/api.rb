module V1
  module Slack
    class API < ApplicationAPI
      namespace :slack do
        resource :statuses do
          desc "Return a public timeline."
          get :public_timeline do
            # Status.limit(20)
            "Hello, Slack!"
          end
        end
      end
    end
  end
end
