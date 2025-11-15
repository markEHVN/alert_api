class EmploymentHero < ApplicationAPI
  mount SignUpAPI => "/sign_up"
  mount LoginAPI => "/login"
  mount UserAPI
  mount BlogAPI
  # mount V1::UserAPI
  # mount V1::AlertAPI
  # mount V1::AlertSubscriptionAPI

  # Catch-all route for unmatched paths (must be last)
  route :any, "*path" do
    error!("Handle /api/* route not found by Grape", 404)
  end
end
