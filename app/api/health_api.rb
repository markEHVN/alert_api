class HealthAPI < Grape::API
  format :json
  get "up" do
    status 200
  end
end
