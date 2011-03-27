class SolutionsController < ApplicationController
  def index
    @task = Task.find params[:task_id]
    @solutions = Solution.for_task params[:task_id]
  end
end
