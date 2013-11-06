module Language
  extend self

  delegate :language, :parsing?, :run_tests, :extension, :solution_dump, to: :current_language

  def current_language
    @current_language ||= const_get Rails.application.config.language.to_s.camelize
  end

  def course_name
    Rails.application.config.course_name
  end

  def email
    Rails.application.config.course_email
  end

  def email_sender
    "#{course_name} <#{email}>"
  end

  def domain
    Rails.application.config.course_domain
  end
end
