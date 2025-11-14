class LoginAPI < ApplicationAPI
  desc "User login"
  params do
    requires :email, type: String
    requires :password, type: String
  end
  post do
    service = LoginService.new(strong_params)
    user = service.call

    if user.nil?
      error!("Invalid email or password", 401)
    end

    user
  end
end
