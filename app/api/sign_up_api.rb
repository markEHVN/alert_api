class SignUpAPI < ApplicationAPI
  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({ messages: e, "is_custom": true, "file_error": "#{__FILE__}:#{__LINE__}" }, 400)
  end

  desc "Get sign up information"
  get do
    { message: "Sign up endpoint", status: "ok" }
  end

  desc "Create a new user account"
  params do
    requires :email, type: String
    requires :password, type: String
    requires :first_name, type: String
    requires :last_name, type: String
  end
  post do
    instance = UserService::Create.new(strong_params)
    instance.call
  end
end
