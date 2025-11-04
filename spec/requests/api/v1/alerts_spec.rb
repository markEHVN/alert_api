require "rails_helper"

RSpec.describe "Api::V1::Alerts", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { "Authorization" => "Bearer #{user.auth_token}" } }

  describe "GET /api/v1/alerts" do
    let!(:alerts) { create_list(:alert, 3, user: user) }
    # TODO: Test successful alert listing
    it "returns all user alerts" do
      get "/api/v1/alerts", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response["data"]).to have_attributes(size: 3)
    end
    # TODO: Test filtering by severity
    it "filters alerts by severity" do
      create(:alert, severity: "critical", user: user)
      get "/api/v1/alerts", params: { severity: "critical" }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response["data"]).to have_attributes(size: 1)
      expect(json_response["data"].first["attributes"]["severity"]).to eq("critical")
    end
    # TODO: Test authentication required
  end

  describe "POST /api/v1/alerts" do
    let(:alert_params) do
      {
        alert: {
          title: "Test Alert",
          message: "This is a test alert",
          severity: "high",
          category: "system"
        }
      }
    end
    # TODO: Test alert creation
    it "creates a new alert" do
      expect {
        post "/api/v1/alerts", params: alert_params, headers: headers
      }.to change(Alert, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json_response["data"]["attributes"]["title"]).to eq("Test Alert")
    end
    # TODO: Test validation errors
    it "returns validation errors for invalid data" do
      alert_params[:alert][:title] = ""
      post "/api/v1/alerts", params: alert_params, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["errors"]).to be_present
    end
    # TODO: Test authentication required
  end

  describe "PATCH /api/v1/alerts/:id/acknowledge" do
    let(:alert) { create(:alert, user: user) }
    # TODO: Test alert acknowledgment
    it "acknowledges the alert" do
      patch "/api/v1/alerts/#{alert.id}/acknowledge", headers: headers
      expect(response).to have_http_status(:ok)
      expect(alert.reload).to be_acknowledged
      expect(json_response["data"]["attributes"]["acknowledged_at"]).to be_present
    end
    # TODO: Test user can only acknowledge their own alerts
  end
end
