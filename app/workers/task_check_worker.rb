class TaskCheckWorker
  include Sidekiq::Worker
  extend QueueMonitoring

  def perform(task_id)
    task    = Task.find task_id
    checker = TaskChecker.new task
    checker.run
  end
end
