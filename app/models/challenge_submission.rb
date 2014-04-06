class ChallengeSubmission
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_reader :user, :challenge
  attr_accessor :code

  validates :code, presence: { message: 'не сте предали код' }

  validate :challenge_must_be_open
  validate :code_is_parsable

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
    @code = attributes[:code]

    return false unless valid?

    solution = ChallengeSolution.for(@challenge, @user)

    if solution
      solution.update_attributes! code: code
    else
      ChallengeSolution.create! code: code, user: @user, challenge: @challenge
    end

    true
  end

  private

  def challenge_must_be_open
    errors.add :base, 'крайният срок на задачата вече е изтекъл' if @challenge.closed?
  end

  def code_is_parsable
    unless Language.parsing? code
      errors.add :code, 'имате синтактична грешка'
    end
  end
end
