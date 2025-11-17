class BlogService
  class GetAll
    def initialize(scope, params)
      @scope = scope
      @params = params
    end

    def call
      blogs = @scope.includes(:user)
      blogs = blogs.page(@params[:page] || 1).per(@params[:per_page] || 25)

      {
        data: BlogSerializer.new(blogs).serializable_hash[:data],
        meta: {
          current_page: blogs.current_page,
          per_page: blogs.limit_value,
          total_pages: blogs.total_pages,
          total_count: blogs.total_count
        }
      }
    end
  end

  class Detail
    def initialize(scope, params)
      @scope = scope
      @params = params
    end

    def call
      @scope.find(@params[:id])
    end
  end

  class Schedule
    def initialize(user_id, id)
      @user_id = user_id
      @id = id
    end

    def call
      user = User.find(@user_id)
      blog = user.blogs.find(@id)
      blog.update!(status: :published)
    end
  end
end
