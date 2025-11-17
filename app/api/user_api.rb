class UserAPI < ApplicationAPI
  namespace :users do
    desc "Retrieve all users"
    params do
      optional :page, type: Integer, desc: "Page number for pagination"
      optional :per_page, type: Integer, desc: "Number of users per page"
    end
    get do
      authorize User, :index?
      instance = UserService::GetAll.new(strong_params)
      instance.call
    end

    desc "Retrieve the current user"
    get "me" do
      instance = UserService::Me.new(current_user)
      instance.call
    end

    desc "Update a user"
    params do
      requires :id, type: Integer, desc: "ID of the user"
      optional :email, type: String, desc: "Email of the user"
      optional :role, type: String, values: [ "user", "admin" ], desc: "Role of the user"
      optional :first_name, type: String, desc: "First name of the user"
      optional :last_name, type: String, desc: "Last name of the user"
      optional :password, type: String, desc: "Password of the user"
    end
    patch ":id" do
      user_to_update = User.find(params[:id])
      authorize user_to_update, :update?
      instance = UserService::Update.new(params[:id], strong_params(include_missing: false, except: [ :id ]))
      instance.call
    end

    desc "Delete a user account"
    params do
      requires :id, type: Integer
    end
    delete ":id" do
      user_to_delete = User.find(params[:id])
      authorize user_to_delete, :delete?
      instance = UserService::Delete.new(strong_params)
      instance.call
    end
  end
end
