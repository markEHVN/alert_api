class EmploymentHero < Grape::API
  version "v1", using: :path
  format :json
  prefix :api

  mount V1::Alert::API
  mount V1::AlertSubscription::API
  mount V1::User::API
end
