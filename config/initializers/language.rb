language_file = Rails.root.join('config/language.txt')

if not language_file.exist? and Rails.env.production?
  raise "#{language_file} must contain a language"
end

language = if language_file.exist? and not Rails.env.test?
  language_file.read.strip
else
  'Ruby'
end

Trane::Application.config.language = language.to_sym
