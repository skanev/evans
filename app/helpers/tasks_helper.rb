module TasksHelper
  def show_results?(task)
    task.checked? or admin?
  end

  def toggle_comment_star_link(comment)
    render 'common/toggle_contribution_star', star_path: star_revision_comment_path(comment.revision, comment),
                                              unstar_path: unstar_revision_comment_path(comment.revision, comment)
  end
end
