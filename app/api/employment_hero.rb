class EmploymentHero < Grape::API
  format :json

  mount V1::Alert::API => "/v1"
  mount V1::AlertSubscription::API => "/v1"
end
