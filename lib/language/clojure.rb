# encoding: utf-8
module Language::Clojure
  extend self

  def language
    :clojure
  end

  def run_tests(test, solution)
    raise NotImplementedError
  end
end
