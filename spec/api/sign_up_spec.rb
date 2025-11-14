require "rails_helper"

RSpec.describe SignUpAPI, type: :request do
  describe "GET /api/sign_up" do
    it "returns the sign up form" do
      get "/api/sign_up"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/sign_up" do
    it "creates a new user" do
      user_params = {
        email: "test@example.com",
        password: "password",
        first_name: "John",
        last_name: "Doe"
      }

      user_service_instance = instance_double(UserService::Create)
      allow(UserService::Create).to receive(:new).and_return(user_service_instance)
      allow(user_service_instance).to receive(:call).and_return(build(:user))

      post "/api/sign_up", params: user_params

      expect(response).to have_http_status(:created)
    end

    context "params validation" do
      it "creates a new user failed without email provided" do
        user_params = {
          password: "password",
          first_name: "John",
          last_name: "Doe"
        }

        post "/api/sign_up", params: user_params

        expect(response).to have_http_status(400)
      end

      it "creates a new user failed without password provided" do
        user_params = {
          email: "test@example.com",
          first_name: "John",
          last_name: "Doe"
        }

        post "/api/sign_up", params: user_params

        expect(response).to have_http_status(400)
      end

      it "creates a new user failed without first_name provided" do
        user_params = {
          email: "test@example.com",
          password: "password",
          last_name: "Doe"
        }

        post "/api/sign_up", params: user_params

        expect(response).to have_http_status(400)
      end

      it "creates a new user failed without last_name provided" do
        user_params = {
          email: "test@example.com",
          password: "password",
          first_name: "John"
        }

        post "/api/sign_up", params: user_params

        expect(response).to have_http_status(400)
      end
    end
  end
end
