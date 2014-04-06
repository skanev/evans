class Quiz < ActiveRecord::Base
  has_many :results, class_name: 'QuizResult'

  validates :name, presence: true
end
