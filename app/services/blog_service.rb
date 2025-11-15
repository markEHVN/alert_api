class BlogService
  class GetAll
    def initialize(scope, params)
      @scope = scope
      @params = params
    end

    def call
      # Use the scoped relation instead of Blog.all
      # Preload user association to avoid N+1 in serializer
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
end
