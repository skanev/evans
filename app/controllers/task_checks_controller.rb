class TaskChecksController < ApplicationController
  before_action :require_admin

  def create
    task_id = params[:task_id]
    TaskCheckWorker.perform_async task_id unless TaskCheckWorker.queued? task_id
    redirect_to task_solutions_path(task_id), notice: 'Проверката е поставена в опашката'
  end
end
