class MySolutionsController < ApplicationController
  before_filter :require_user

  def show
    @task = Task.find params[:task_id]
    @code = Solution.code_for(current_user, @task)
  end

  def update
    @task = Task.find params[:task_id]
    @code = params[:code]

    if Solution.submit current_user, @task, @code
      redirect_to @task, :notice => 'Задачата е предадена успешно!'
    else
      flash.now[:error] = 'Трябва да въведете някакъв код. Очевидно.'
      render :show
    end
  end
end
