class ApplicationController < ActionController::API
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_validation_errors

  private

  def authenticate_user!
    # Look for an Authorization header in the HTTP request
    auth_header = request.headers["Authorization"]
    if auth_header.blank?
      # No header found = user not logged in
      render json: { error: "Please log in to access this API" }, status: 401
      return
    end
    # Extract the token from "Bearer abc123token"
    token = auth_header.split(" ").last
    # Find the user by their token (this is simplified - real apps use JWT)
    @current_user = User.find_by(auth_token: token)
    if @current_user.nil?
      # Invalid token = user not found
      render json: { error: "Invalid login token" }, status: 401
    end
  end

  attr_reader :current_user


  # Handle "record not found" errors (like when Alert ID doesn't exist)
  def render_not_found
    render json: {
      error: "Record not found"
    }, status: 404
  end
  # Handle validation errors (like when required fields are missing)
  def render_validation_errors(exception)
    render json: {
      errors: exception.record.errors.full_messages
    }, status: 422
  end
end
