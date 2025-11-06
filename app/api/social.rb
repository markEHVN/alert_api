class Social < Grape::API
  format :json

  mount V1::Twitter::API => "/v1"
  mount V1::Slack::API => "/v1"

  mount V2::Twitter::API => "/v2"
  mount V2::Slack::API => "/v2"
end
