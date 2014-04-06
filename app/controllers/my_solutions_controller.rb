class MySolutionsController < ApplicationController
  before_action :require_user

  def show
    @task = Task.find params[:task_id]
    @code = Solution.code_for(current_user, @task)
    @submission = Submission.new current_user, @task, @code
  end

  def update
    @task = Task.find params[:task_id]
    @code = params[:submission][:code]
    @submission = Submission.new current_user, @task, @code

    if @submission.submit
      redirect_to @task, notice: 'Задачата е предадена успешно!'
    else
      render :show
    end
  end
end
