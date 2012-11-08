class ChallengeSolution < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  class << self
    def for(challenge, user)
      where(challenge_id: challenge.id, user_id: user.id).first
    end
  end
end
