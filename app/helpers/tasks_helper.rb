module TasksHelper
  def show_results?(task)
    task.checked? or admin?
  end

  def toggle_comment_star_link(comment)
    render 'common/toggle_contribution_star', star_path: revision_comment_star_path(comment.revision, comment),
                                              unstar_path: revision_comment_unstar_path(comment.revision, comment)
  end
end
