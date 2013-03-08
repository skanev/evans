class HomeworkMergePublicWorker
  include Sidekiq::Worker

  def perform
    Sync::Homework.merge_public_repo
  end
end
