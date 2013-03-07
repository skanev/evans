class TaskChecker
  def initialize(task)
    @task = task
    @on_each_solution = lambda { |_| }
  end

  def run
    @task.solutions.each do |solution|
      result = TestRunner.run @task.test_case, solution.code
      passed = result[:passed]
      failed = result[:failed]
      log = result[:log]
      points = Solution.calculate_points passed, failed, @task.max_points

      solution.update_attributes! passed_tests: passed, failed_tests: failed, points: points, log: log

      @on_each_solution.call solution
    end
  end

  def on_each_solution(&block)
    @on_each_solution = block
  end
end
