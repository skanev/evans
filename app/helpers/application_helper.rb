module ApplicationHelper
  def user_thumbnail(user, version = :size150)
    image = user.photo.try(:url, version) || image_path("photoless-user/#{version}.png")
    css_classes = %w(avatar)
    css_classes << "admin" if user.admin?

    image_tag image, alt: user.name, class: css_classes
  end

  def markup(text, options = {})
    options = options.reverse_merge auto_link: true

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

  def tip_of_the_day
    render 'common/tip_of_the_day', tip: Tip.current
  end

  def format_code(code)
    CodeRay.scan(code, Language.language).html(line_numbers: :table, bold_every: false, line_number_anchors: false, css: :class).html_safe
  end
end
