class SolutionsController < ApplicationController
  before_action :require_admin, only: :update

  def index
    @task = Task.find params[:task_id]

    unless @task.has_visible_solutions? or admin?
      deny_access
      return
    end

    @solutions = Solution.for_task params[:task_id]
  end

  def show
    @task          = Task.find params[:task_id]
    @solution      = @task.solutions.find params[:id]
    @history       = SolutionHistory.new @solution
    @last_revision = @solution.last_revision

    deny_access unless @solution.visible_to?(current_user)
  end

  def update
    solution = Solution.find params[:id]
    solution.update_score params[:solution]

    if solution.manually_scored?
      redirect_to unscored_task_solutions_path(solution.task)
    else
      redirect_to solution
    end
  end

  def unscored
    solution = Task.next_unscored_solution params[:task_id]

    if solution
      redirect_to solution
    else
      flash[:notice] = 'Всички решения на тази задача са проверени!'
      redirect_to task_solutions_path(params[:task_id])
    end
  end

  def review
    solution = Solution.find params[:id]
    if solution.reviewer.nil?
      solution.update! reviewer: current_user
      flash[:notice] = 'Ти си проверяващ за тази задача'
    else
      flash[:error] = 'Вече има проверяващ за тази задача'
    end
    redirect_to solution
  end

  def abandon
    solution = Solution.find params[:id]
    if solution.reviewer == current_user
      solution.update! reviewer: nil
      flash[:notice] = 'Вече не проверяваш задачата'
    end
    redirect_to solution
  end
end
