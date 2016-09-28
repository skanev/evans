class Submission
  include ActiveModel::Validations
  include ActiveModel::Naming

  attr_reader :code

  validates :code, presence: { message: 'не сте предали код' }

  validate :task_must_be_open
  validate :code_is_parsable_and_compliant_with_restrictions

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
    violations.present?
  end

  def violations
    return unless Language.can_lint?

    @violations ||= begin
      base_config = YAML.load(FileCache.load(Rails.application.config.rubocop_config_location))

      Language.lint(code, base_config, @task.restrictions_hash).join("\n")
    end
  end

  private

  def task_must_be_open
    errors.add :base, 'задачата е затворена' if @task.closed?
  end

  def code_is_parsable_and_compliant_with_restrictions
    unless Language.parsing? code
      errors.add :code, 'имате синтактична грешка'
      return
    end

    if violating_restrictions?
      errors.add :code, violations
    end
  end
end
