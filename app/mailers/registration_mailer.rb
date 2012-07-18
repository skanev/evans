# encoding: utf-8
class RegistrationMailer < ActionMailer::Base
  default from:     Rails.application.config.email_from,
          reply_to: Rails.application.config.email_from

  def confirmation(sign_up)
    @activation_url = activation_url(sign_up.token, :only_path => false)

    mail :to => sign_up.email,
         :subject => 'Потвърждение на регистрация'
  end

  def activation(user)
    @email = user.email

    mail :to => user.email,
         :subject => 'Успешна регистрация'
  end
end
