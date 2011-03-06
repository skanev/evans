module Markup
  extend self

  def format(text)
    result = Sanitize.clean(text, Sanitize::Config::RELAXED)
    result = RDiscount.new(result).to_html
    result.html_safe
  end
end
