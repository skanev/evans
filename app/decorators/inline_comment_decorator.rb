class InlineCommentDecorator < CommentDecorator
  def user_avatar
    h.link_to h.user_thumbnail(model.user, :size50), model.user
  end

  def permalink
    h.link_to permalink_path, class: 'permalink', title: 'Трайна връзка' do
      "коментира преди #{h.content_tag(:time, h.time_ago_in_words(model.created_at), datetime: model.created_at.iso8601)}".html_safe
    end
  end
end
