class ChallengeSolution < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  scope :in_chronological_order, -> { order 'created_at ASC' }

  class << self
    def for(challenge, user)
      where(challenge_id: challenge.id, user_id: user.id).first
    end

    def for_challenge_with_users(challenge_id)
      in_chronological_order.where(challenge_id: challenge_id).includes(:user)
    end

    def correct?(passed_tests, failed_tests)
      !!(passed_tests.nonzero? and failed_tests.zero?)
    end
  end
end
