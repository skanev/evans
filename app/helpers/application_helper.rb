# encoding: utf-8
module ApplicationHelper
  def user_thumbnail(user)
    image = user.photo.try(:url, :thumb) || image_path('photoless-user.png')
    image_tag image, :alt => user.name
  end

  def markup(text, options = {})
    options = {auto_link: true}.merge options

    formatted = Markup.format(text)
    formatted = auto_link(formatted) if options[:auto_link]

    find_and_preserve(formatted)
  end

  def admin_only(&block)
    yield if current_user.try(:admin?)
    nil
  end

  def authenticated_only(&block)
    yield if logged_in?
    nil
  end

  def markdown_explanation
    render 'common/markdown'
  end

  def rss_feed(url)
    alt_text = 'Абонирайте се за RSS Feed към тази страница'
    link_to image_tag('rss.gif', {:alt => alt_text}), url, :id => 'rss_feed'
  end
end
