class QuizResult < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :user

  validates :quiz_id, :user_id, :correct_answers, :points, presence: true

  def user_name
    user.name
  end
end
