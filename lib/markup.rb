module Markup
  extend self

  SANITIZE_CONFIG = Sanitize::Config::RELAXED.dup
  SANITIZE_CONFIG[:attributes]['pre'] = ['class']

  def format(text)
    result = RDiscount.new(text).to_html
    result = Sanitize.clean(result, SANITIZE_CONFIG)
    result.html_safe
  end
end
