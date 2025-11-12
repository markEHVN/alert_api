class EmploymentHero < ApplicationAPI
  format :json

  mount SignUpAPI
  # mount V1::UserAPI
  # mount V1::AlertAPI
  # mount V1::AlertSubscriptionAPI
end
