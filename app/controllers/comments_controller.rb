# encoding: utf-8
class CommentsController < ApplicationController
  # TODO Restrict access when task is not closed (admins and user)
  # TODO Make sure that passing another task_id != solution.task_id won't surpass restrictions
  # TODO Redirect to last comment
  def create
    solution = Solution.find params[:solution_id]

    comment = solution.comments.build params[:comment]
    comment.user = current_user
    comment.save!

    redirect_to solution, notice: 'Коментарът е добавен успешно'
  end
end
