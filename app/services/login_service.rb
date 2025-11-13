class LoginService
  def initialize(params)
    @params = params
  end

  def call
    User.find_by(email: @params[:email], password: @params[:password])
  end
end
