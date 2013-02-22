module Language
  extend self

  delegate :language, :course_name, :run_tests, to: :current_language

  def language_name=(name)
    @current_language = const_get name.to_s.camelize
  end

  def current_language
    @current_language or raise 'Language.language_name is not defined by config/initializers/language.rb'
  end
end
