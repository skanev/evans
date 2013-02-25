# encoding: utf-8
module Language::Python
  extend self

  def language
    :python
  end

  def course_name
    "Програмиране с Python"
  end

  def email
    'fmi@py-bg.net'
  end

  def domain
    'fmi.py-bg.net'
  end

  def run_tests(test, solution)
    raise NotImplementedError
  end
end

