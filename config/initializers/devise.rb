Devise.setup do |config|
  require 'devise/orm/active_record'

  config.stretches = 10
  config.encryptor = :bcrypt
  config.pepper = Rails.application.config.pepper
  config.remember_for = 2.weeks

  config.password_length = 6..20
  config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  config.mailer_sender = Language.email_sender
end
