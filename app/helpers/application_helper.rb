module ApplicationHelper
  def user_thumbnail(user)
    image = user.photo.try(:url, :thumb) || image_path('photoless-user.png')
    image_tag image, :alt => user.name
  end

  def markup(text)
    auto_link Markup.format(text)
  end
end
