class BlogAPI < ApplicationAPI
  namespace :blogs do
    get do
      authorize Blog, :index?
      scoped_blogs = policy_scope(Blog)

      instance = BlogService::GetAll.new(scoped_blogs, strong_params)
      instance.call
    end
  end
end
