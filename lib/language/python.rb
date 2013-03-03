# encoding: utf-8
module Language::Python
  extend self

  def language
    :python
  end

  def run_tests(test, solution)
    raise NotImplementedError
  end
end

