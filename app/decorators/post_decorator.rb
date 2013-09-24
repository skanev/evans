class PostDecorator < ContributionDecorator
  delegate_all

  def dom_id
    h.dom_id model
  end

  def permalink_path
    h.post_path model
  end

  def star_link
    h.toggle_post_star_link model if h.admin?
  end

  def starred?
    model.starred?
  end

  def edit_path
    h.edit_post_path model
  end
end
