class LecturesWorker
  include Sidekiq::Worker

  def perform
    system 'rake lectures:compile'
  end
end
