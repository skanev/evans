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
      solution = ChallengeSolution.for(challenge, user)
      code     = solution.try(:code)

      new challenge, user, code
    end
  end

  def persisted?
    false
  end

  def update(attributes)
    solution = ChallengeSolution.for(challenge, user)
    code     = attributes[:code]

    if solution
      solution.update_attributes! code: code
    else
      ChallengeSolution.create! code: code, user: user, challenge: challenge
    end

    true
  end
end
