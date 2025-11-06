module V1
  module User
    class API < ApplicationAPI
      # Explicitly include shared helpers to ensure they're available
      helpers ApplicationAPI::SharedHelpers

      helpers do
        def find_user!
          @user = find_record!(::User, params[:id])
        end
      end

      namespace :users do
        desc "Get all users (admin only)"
        params do
          optional :page, type: Integer, desc: "Page number for pagination"
          optional :per_page, type: Integer, desc: "Number of items per page"
        end
        get do
          authenticate!

          # Check if current user is admin
          error!("Access denied. Admin privileges required.", 403) unless current_user.admin?

          users = ::User.all
          users = users.page(params[:page] || 1).per(params[:per_page] || 25)

          {
            data: UserSerializer.new(users).serializable_hash[:data],
            meta: {
              current_page: users.current_page,
              per_page: users.limit_value,
              total_pages: users.total_pages,
              total_count: users.total_count
            }
          }
        end

        desc "Create a new user"
        params do
          requires :email, type: String, desc: "User email"
          requires :first_name, type: String, desc: "User first name"
          requires :last_name, type: String, desc: "User last name"
          optional :role, type: String, desc: "User role (user or admin)", default: "user"
        end
        post do
          user_params = {
            email: params[:email],
            first_name: params[:first_name],
            last_name: params[:last_name],
            role: params[:role]
          }

          user = ::User.new(user_params)

          if user.save
            {
              data: UserSerializer.new(user).serializable_hash[:data],
              message: "User created successfully"
            }
          else
            error!(user.errors.full_messages, 422)
          end
        end

        desc "Get current user profile"
        get :me do
          authenticate!

          {
            data: UserSerializer.new(current_user).serializable_hash[:data]
          }
        end

        route_param :id do
          desc "Get a specific user by ID"
          get do
            authenticate!
            find_user!

            {
              data: UserSerializer.new(@user).serializable_hash[:data]
            }
          end

          desc "Update a user"
          params do
            optional :email, type: String, desc: "User email"
            optional :first_name, type: String, desc: "User first name"
            optional :last_name, type: String, desc: "User last name"
            optional :role, type: String, desc: "User role (user or admin)"
          end
          put do
            authenticate!
            find_user!

            # Users can only update their own profile unless they're admin
            error!("Access denied", 403) unless current_user.admin? || current_user.id == @user.id

            # Only admins can change roles
            if params[:role] && !current_user.admin?
              error!("Access denied. Admin privileges required to change role.", 403)
            end

            update_params = params.slice(:email, :first_name, :last_name, :role)

            if @user.update(update_params)
              {
                data: UserSerializer.new(@user).serializable_hash[:data],
                message: "User updated successfully"
              }
            else
              error!(@user.errors.full_messages, 422)
            end
          end

          desc "Delete a user (admin only)"
          delete do
            authenticate!
            find_user!

            # Only admins can delete users
            error!("Access denied. Admin privileges required.", 403) unless current_user.admin?

            # Prevent admin from deleting themselves
            error!("Cannot delete your own account", 422) if current_user.id == @user.id

            @user.destroy

            {
              message: "User deleted successfully"
            }
          end
        end
      end
    end
  end
end
