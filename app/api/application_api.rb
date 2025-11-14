class ApplicationAPI < Grape::API
  format :json
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!("Record not found !!", 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error!(e.record.errors.full_messages, 422)
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    error!("You are not authorized to perform this action", 403)
  end

  # Make Pundit methods available as helpers
  helpers Pundit::Authorization

  helpers do
    def strong_params(options = {})
      exclude = options.delete(:except) || []
      declared(params, options).except(*exclude)
    end

    def authenticate!
      current_user
    end

    def current_user
      @current_user ||= authenticate_user!
    end

    def authenticate_user!
      auth_header = headers["Authorization"]
      if auth_header.blank?
        error!("Please log in to access this API", 401)
      end

      token = auth_header.split(" ").last

      user = User.find_by(auth_token: token)
      if user.nil?
        error!("Invalid login token", 401)
      end

      user
    end
  end
end
