class LecturesWorker
  include Sidekiq::Worker

  def perform
    system 'bundle exec rake lectures:compile'
  end
end
