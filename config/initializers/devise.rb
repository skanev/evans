pepper_file = Rails.root.join('config/pepper.txt')

if not pepper_file.exist? and Rails.env.production?
  raise "#{pepper_file} must contain pepper"
end

pepper = if pepper_file.exist?
  pepper_file.read.strip
else
  'cc1a01a066c8130b357fb77069dcae04b459a4ec8950f6245bcab82487832b4a4ec0c093be4c84aa6cfd934c41fd217cfb55c4af19704ca95b29e8140e9dfbb9'
end

Devise.setup do |config|
  require 'devise/orm/active_record'

  config.stretches = 10
  config.encryptor = :bcrypt
  config.pepper = pepper
  config.remember_for = 2.weeks

  config.password_length = 6..20
  config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
end
