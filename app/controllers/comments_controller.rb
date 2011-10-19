class CommentsController < ApplicationController
  # TODO Restrict access when task is not closed (admins and user)
  # TODO Make sure that passing another task_id != solution.task_id won't surpass restrictions
  def create
    solution = Solution.find params[:solution_id]
    Comment.submit solution, current_user, params[:comment]
    redirect_to solution
  end
end
