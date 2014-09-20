module TasksHelper
  def show_results?(task)
    task.checked? or admin?
  end

  def toggle_comment_star_link(comment)
    render 'comments/toggle_comment_star', comment: comment
  end
end
