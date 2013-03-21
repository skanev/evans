class ChallengeSolution < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  class << self
    def for(challenge, user)
      where(challenge_id: challenge.id, user_id: user.id).first
    end

    def correct?(passed_tests, failed_tests)
      !!(passed_tests.nonzero? and failed_tests.zero?)
    end
  end
end
