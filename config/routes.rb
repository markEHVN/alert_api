Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # namespace :api do
  #   namespace :v1 do
  #     resources :alerts do
  #       member do
  #         patch :acknowledge
  #         patch :resolve
  #       end
  #       collection do
  #         get :unread_count
  #       end
  #       resources :subscriptions, controller: "alert_subscriptions", except: [ :show, :update ]
  #     end
  #   end
  # end

  mount Social => "/social"
  mount EmploymentHero => "/"
end
