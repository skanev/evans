# encoding: utf-8
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
      redirect_to @task, :notice => 'Задачата е предадена успешно!'
    else
      flash.now[:error] = 'Вашето решение не бе прието.'
      render :show
    end
  end
end
