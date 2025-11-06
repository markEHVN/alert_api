class EmploymentHero < Grape::API
  format :json

  mount V1::Alert::API => "/api/v1"
  mount V1::AlertSubscription::API => "/api/v1"
end
