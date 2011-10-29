class SolutionsController < ApplicationController
  def index
    @task = Task.find params[:task_id]

    unless @task.closed? or admin?
      deny_access
      return
    end

    @solutions = Solution.for_task params[:task_id]
  end

  def show
    @task     = Task.find params[:task_id]
    @solution = Solution.find params[:id]

    deny_access unless @task.closed? or @solution.commentable_by?(current_user)
  end
end
