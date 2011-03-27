class SolutionsController < ApplicationController
  before_filter :require_closed_task_or_admin

  def index
    @task = find_task
    @solutions = Solution.for_task params[:task_id]
  end

  private

  def require_closed_task_or_admin
    deny_access unless find_task.closed? or admin?
  end

  def find_task
    Task.find params[:task_id]
  end
end
