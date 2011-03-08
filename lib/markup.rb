module Markup
  extend self

  SANITIZE_CONFIG = Sanitize::Config::RELAXED.dup
  SANITIZE_CONFIG[:attributes]['pre'] = ['class']

  def format(text)
    result = Sanitize.clean(text, SANITIZE_CONFIG)
    result = RDiscount.new(result).to_html
    result.html_safe
  end
end
