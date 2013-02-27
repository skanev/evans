# encoding: utf-8
module Language::Clojure
  extend self

  def language
    :clojure
  end

  def course_name
    "Практическо функционално програмиране с Clojure"
  end

  def email
    'fmi@clojure.bg'
  end

  def domain
    'fmi.clojure.bg'
  end

  def run_tests(test, solution)
    raise NotImplementedError
  end
end
