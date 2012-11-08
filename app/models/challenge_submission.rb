class ChallengeSubmission
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_reader :user, :challenge
  attr_accessor :code

  def initialize(challenge, user, code)
    @challenge = challenge
    @user      = user
    @code      = code
  end

  class << self
    def for(challenge, user)
      solution = ChallengeSolution.where(user_id: user.id, challenge_id: challenge.id).first
      code     = solution.try(:code)

      new challenge, user, code
    end
  end

  def persisted?
    false
  end

  def update(attributes)
    ChallengeSolution.create! code: attributes[:code], user: user, challenge: challenge
  end
end
