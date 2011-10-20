class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    SolutionMailer.new_comment(comment).deliver unless comment.user == comment.solution.user
  end
end
