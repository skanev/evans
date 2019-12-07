class CommentDecorator < ContributionDecorator
  delegate_all

  def dom_id
    "comment-#{model.id}"
  end

  def css_class
    "comment"
  end

  def permalink_path
    model
  end

  def star_link
    h.toggle_comment_star_link model if h.admin?
  end

  def starred?
    model.starred?
  end

  def edit_path
    [:edit, model.revision, model]
  end
end
