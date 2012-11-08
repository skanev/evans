# encoding: utf-8
class ChallengeSubmission
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_reader :user, :challenge
  attr_accessor :code

  validate :challenge_must_be_open

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
    return false unless valid?

    solution = ChallengeSolution.for(@challenge, @user)
    code     = attributes[:code]

    if solution
      solution.update_attributes! code: code
    else
      ChallengeSolution.create! code: code, user: @user, challenge: @challenge
    end

    true
  end

  private

  def challenge_must_be_open
    errors.add :base, 'Крайния срок на задачата вече е изтекъл' if @challenge.closed?
  end
end
