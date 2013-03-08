class HomeworkSyncWorker
  include Sidekiq::Worker

  def perform
    Sync::Homework.sync_hidden_repo
  end
end
