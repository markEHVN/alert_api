class Rock::HardJob
  include Sidekiq::Job

  def perform(*args)
  end
end
