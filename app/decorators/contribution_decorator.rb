class ContributionDecorator < Draper::Decorator
  def dom_id
    nil
  end

  def css_class
    nil
  end

  def user_avatar
    h.link_to h.user_thumbnail(model.user), model.user
  end

  def user_name
    h.link_to model.user.name, model.user
  end

  def permalink
    h.link_to permalink_path, class: 'permalink', title: 'Трайна връзка' do
      "Публикувано преди #{h.content_tag(:time, h.time_ago_in_words(model.created_at), datetime: model.created_at.iso8601)}".html_safe
    end
  end

  def edit_link
    if h.can_edit? model
      h.link_to 'Редактирай', edit_path
    end
  end

  def star_link
    nil
  end

  def starred?
    false
  end
end
