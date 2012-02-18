class SolutionsController < ApplicationController
  before_filter :require_admin, only: :update

  def index
    @task = Task.find params[:task_id]

    unless @task.closed? or admin?
      deny_access
      return
    end

    @solutions = Solution.for_task params[:task_id]

    respond_to do |format|
      format.html
      format.rss do
        @comments = get_comments_for_task(@task)
        response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8'
      end
    end
  end

  def show
    @task     = Task.find params[:task_id]
    @solution = @task.solutions.find params[:id]

    deny_access unless @task.closed? or @solution.commentable_by?(current_user)
  end

  def update
    solution = Solution.find params[:id]
    solution.update_attributes! params[:solution]
    redirect_to solution
  end

  def get_comments_for_task(task)
    task.solutions
        .map { |solution| solution.comments }
        .inject(:+)
        .to_a
        .sort_by { |comment| comment.created_at }
  end
end
