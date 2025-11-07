class HardJob
  include Sidekiq::Job

  def perform(*args)
    puts args
  end
end
