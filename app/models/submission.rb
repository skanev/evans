class Submission
  extend ActiveSupport::Memoizable

  def initialize(user, task, code)
    @user = user
    @task = task
    @code = code
  end

  def submit
    return false if @task.closed?
    return false if violating_restrictions?
    solution = Solution.for(@user, @task) || Solution.new(:user_id => @user.id, :task_id => @task.id)
    solution.update_attributes :code => @code
  end

  def violating_restrictions?
    critic.criticism.present?
  end

  def violations
    critic.criticism.map { |violation, rule| "#{rule}: #{violation}" }.join("\n")
  end

  private

  def critic
    Skeptic::Critic.new.tap do |critic|
      @task.restrictions_hash.each do |rule, option|
        critic.send "#{rule}=", option
      end

      critic.criticize @code
    end
  end
  memoize :critic
end
