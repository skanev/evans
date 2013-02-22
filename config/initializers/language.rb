file = Rails.root.join('config/language.txt')

case Rails.env
when "production"
  raise 'There needs to be a config/language.txt file.' unless file.exist?
  Language.language_name = file.read.strip
when "test"
  Language.language_name = 'ruby'
else
  Language.language_name = file.exist? ? file.read.strip : 'ruby'
end
