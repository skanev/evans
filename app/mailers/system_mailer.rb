class SystemMailer < ActionMailer::Base
  default from: Language.email_sender, reply_to: Language.email

  def lectures_build_error(backtrace)
    @backtrace = backtrace

    mail to: Language.email, subject: 'Грешка при build на лекциите'
  end
end
