class MySolutionsController < ApplicationController
  before_filter :require_user

  def show
    @task = Task.find params[:task_id]
    @code = Solution.code_for(current_user, @task)
  end

  def update
    @task = Task.find params[:task_id]
    @code = params[:code]
    @submission = Submission.new current_user, @task, @code

    if @submission.submit
      redirect_to @task, notice: 'Задачата е предадена успешно!'
    else
      flash.now[:error] = "Решението ти не бе прието. #{@submission.error}"
      render :show
    end
  end
end
