class Blog::ScheduleJob
  include Sidekiq::Job

  def perform(*args)
    puts "Schedule Job Change status of blog to published"
    user_id = args[0]
    id = args[1]
    instance = BlogService::Schedule.new(user_id, id)
    instance.call
  end
end
