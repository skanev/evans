class Submission
  def initialize(user, task, code)
    @user = user
    @task = task
    @code = code
  end

  def submit
    return false if @task.closed?
    solution = Solution.for(@user, @task) || Solution.new(:user_id => @user.id, :task_id => @task.id)
    solution.update_attributes :code => @code
  end
end
