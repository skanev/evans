# encoding: utf-8
module Language
  extend self
  delegate :language, :course_name, :run, :to => Trane::Application.config.language
end
