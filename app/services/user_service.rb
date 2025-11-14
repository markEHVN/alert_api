module UserService
  class Create
    def initialize(params)
      @params = params
    end

    def call
      user = User.create!(@params)
      {
        data: UserSerializer.new(user).serializable_hash[:data]
      }
    rescue ActiveRecord::RecordInvalid => e
      { is_custom: true, messages: e.record.errors, file_error: "#{__FILE__}:#{__LINE__}" }
    end
  end

  class Update
    def initialize(id, params)
      @id = id
      @params = params
    end

    def call
      puts @params
      puts @id
      user = User.find(@id)
      puts user
      user.update!(@params)
      {
        data: UserSerializer.new(user).serializable_hash[:data]
      }
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
      { is_custom: true, messages: e, file_error: "#{__FILE__}:#{__LINE__}" }
    end
  end

  class Delete
    def initialize(params)
      @params = params
    end

    def call
      user = User.find(@params[:id])
      user.destroy!
      {
        data: UserSerializer.new(user).serializable_hash[:data],
        message: "User deleted successfully"
      }
    rescue ActiveRecord::RecordNotFound => e
      { is_custom: true, messages: e, file_error: "#{__FILE__}:#{__LINE__}" }
    end
  end

  class GetAll
    def initialize(params)
      @params = params
    end

    def call
      users = User.all

      users = users.page(@params[:page] || 1).per(@params[:per_page] || 25)

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
  end
end
