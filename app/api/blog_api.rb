class BlogAPI < ApplicationAPI
  namespace :blogs do
    get do
      authorize Blog, :index?
      scoped_blogs = policy_scope(Blog)

      instance = BlogService::GetAll.new(scoped_blogs, strong_params)
      instance.call
    end

    desc "Schedule a blog post to be published"
    params do
      requires :id, type: Integer, desc: "ID of the blog post"
      requires :publish_at, type: DateTime, desc: "Scheduled publish time"
    end
    post ":id/schedule" do
      authorize Blog, :schedule?
      scoped_blogs = policy_scope(Blog)

      instance = BlogService::Detail.new(scoped_blogs, params)
      blog = instance.call

      publish_time = params[:publish_at] || Time.now
      Blog::ScheduleJob.perform_at(publish_time, current_user.id, blog.id)
      { message: "Blog scheduled for publishing", publish_at: publish_time }
    end
  end
end
