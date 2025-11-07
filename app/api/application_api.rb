class ApplicationAPI < Grape::API
  format :json

  # Global error handling - similar to rescue_from in ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    error!("Record not found", 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error!(e.record.errors.full_messages, 422)
  end

  # Define a module for shared helpers
  module SharedHelpers
    def current_user
      @current_user ||= authenticate_user!
    end

    def authenticate_user!
      # Look for an Authorization header in the HTTP request
      auth_header = headers["Authorization"]
      if auth_header.blank?
        # No header found = user not logged in
        error!("Please log in to access this API", 401)
      end

      # Extract the token from "Bearer abc123token"
      token = auth_header.split(" ").last

      # Find the user by their token (this matches your ApplicationController logic)
      user = User.find_by(auth_token: token)
      if user.nil?
        # Invalid token = user not found
        error!("Invalid login token", 401)
      end

      user
    end

    # Convenience method to ensure user is authenticated
    def authenticate!
      current_user # This will trigger authentication and error if not authenticated
    end

    # Helper for finding records with proper error handling
    def find_record!(model_class, id, scope: nil)
      if scope
        scope.find(id)
      else
        model_class.find(id)
      end
    rescue ActiveRecord::RecordNotFound
      error!("#{model_class.name} not found", 404)
    end

    # Policy authorization helper
    def authorize!(record, action = nil)
      # Determine the policy class based on the record
      policy_class = "#{record.class.name}Policy".constantize
      policy = policy_class.new(current_user, record)

      # If no specific action is provided, infer it from the current HTTP method
      action ||= case request.request_method.downcase
      when "get" then params[:id] ? :show : :index
      when "post" then :create
      when "patch", "put" then :update
      when "delete" then :destroy
      end

      # Check if the user is authorized for this action
      unless policy.public_send("#{action}?")
        error!("You are not authorized to perform this action", 403)
      end
    end

    def authorize_class!(policy_name, action = nil)
      policy_class = "#{policy_name}Policy".constantize
      policy = policy_class.new(current_user, nil)

      action ||= case request.request_method.downcase
      when "get" then :index?
      when "post" then :create?
      end

      unless policy.public_send("#{action}?")
        error!("You are not authorized to perform this action", 403)
      end
    end
  end

  # Include the helpers in this base class
  helpers SharedHelpers
end
