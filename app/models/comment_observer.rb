class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    return if comment.user == comment.solution.user
    return unless comment.solution.user.comment_notification?

    SolutionMailer.new_comment(comment).deliver
  end
end
