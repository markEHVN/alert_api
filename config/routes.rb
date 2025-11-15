require "sidekiq/web"

Rails.application.routes.draw do
  mount HealthAPI => "/"
  mount EmploymentHero => "/api"
  mount Sidekiq::Web => "/sidekiq"
end
