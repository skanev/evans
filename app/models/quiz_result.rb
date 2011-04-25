class QuizResult < ActiveRecord::Base
  validates_presence_of :quiz_id, :user_id, :correct_answers, :points

  belongs_to :quiz
  belongs_to :user

  def user_name
    user.name
  end
end
