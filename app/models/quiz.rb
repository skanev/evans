class Quiz < ActiveRecord::Base
  validates_presence_of :name

  has_many :results, class_name: 'QuizResult'
end
