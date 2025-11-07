module V2
  module Twitter
    class API < Grape::API
      namespace :twitter do
        resource :statuses do
          desc "Return a public timeline."
          get :public_timeline do
            "Hello, Twitter V2!"
          end
        end
      end
    end
  end
end
