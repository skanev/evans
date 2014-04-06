class Submission
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_reader :code

  validates :code, presence: { message: 'не сте предали код' }

  validate :task_must_be_open
  validate :code_is_parsable_and_compliant_with_skeptic_requirements

  def initialize(user, task, code)
    @user = user
    @task = task
    @code = code
  end

  def submit
    return false unless valid?

    solution = Solution.for(@user, @task)

    if solution
      Revision.create! solution: solution, code: @code unless solution.code == @code
    else
      solution = Solution.create! user_id: @user.id, task_id: @task.id
      Revision.create! solution: solution, code: @code
    end

    true
  end

  def violating_restrictions?
    critic.criticism.present?
  end

  def violations
    critic
      .criticism
      .group_by { |violation, rule| rule }
      .map { |rule, arrays| rule + "\n" + arrays.map { |message, _| "* #{message}" }.join("\n") }
      .join("\n\n")
  end

  private

  def critic
    @critic ||= Skeptic::Critic.new.tap do |critic|
      @task.restrictions_hash.each do |rule, option|
        critic.send "#{rule}=", option
      end

      critic.criticize code
    end
  end

  def task_must_be_open
    errors.add :base, 'задачата е затворена' if @task.closed?
  end

  def code_is_parsable_and_compliant_with_skeptic_requirements
    unless Language.parsing? code
      errors.add :code, 'имате синтактична грешка'
      return
    end

    if violating_restrictions?
      errors.add :code, violations
    end
  end
end
