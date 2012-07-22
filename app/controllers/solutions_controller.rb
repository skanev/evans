class SolutionsController < ApplicationController
  before_filter :require_admin, only: :update

  def index
    @task = Task.find params[:task_id]

    unless @task.closed? or admin?
      deny_access
      return
    end

    @solutions = Solution.for_task params[:task_id]
  end

  def show
    @task          = Task.find params[:task_id]
    @solution      = @task.solutions.find params[:id]
    @last_revision = @solution.revisions.last

    deny_access unless @task.closed? or @solution.commentable_by?(current_user)
  end

  def update
    solution = Solution.find params[:id]
    solution.update_attributes! params[:solution]
    redirect_to solution
  end
end
