class TaskChecker
  def initialize(task)
    @task = task
    @on_each_solution = lambda { |_| }
  end

  def run
    @task.solutions.each do |solution|
      results = Language.run_tests @task.test_case, solution.code
      points  = Solution.calculate_points results.passed_count, results.failed_count, @task.max_points

      solution.update_attributes!({
        passed_tests: results.passed_count,
        failed_tests: results.failed_count,
        points: points,
        log: results.log,
      })

      @on_each_solution.call solution
    end
  end

  def on_each_solution(&block)
    @on_each_solution = block
  end
end
