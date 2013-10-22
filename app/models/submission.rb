class Submission
  attr_reader :error

  def initialize(user, task, code)
    @user = user
    @task = task
    @code = code
  end

  def submit
    @error = "Задачата е затворена." if @task.closed?
    @error = "Не си предал код." if @code.blank?
    @error = "Имаш синтактична грешка." unless Language.parses? @code
    @error = "Нарушаваш изискванията на Skeptic." if violating_restrictions?

    return false if @error

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

      critic.criticize @code
    end
  end
end
