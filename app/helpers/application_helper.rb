module ApplicationHelper
  def user_thumbnail(user)
    image = user.photo.try(:url, :thumb) || image_path('photoless-user.png')
    image_tag image, alt: user.name
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

  # A *very* ugly way to get CodeRay to display formatted code in the way we
  # want it. Naturally, using the table format in CodeRay is good enough for
  # just showing it, but commenting on specific lines add a bunch of
  # requirements on what we want to show.
  def format_code(code)
    content_tag :table, class: 'CodeRay' do
      lines = CodeRay.scan(code, Language.language).html(line_numbers: :inline, bold_every: false, line_number_anchors: false, css: :class).lines
      rows  = lines.map { |line| line.sub %r{\A<span class="line-numbers">(\s*\d+)</span>(.*)\Z}, '<tr><td>\1</td><td>\2</td></tr>' }
      rows.join("\n").html_safe
    end
  end
end
