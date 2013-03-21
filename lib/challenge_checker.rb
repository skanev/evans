class ChallengeChecker
  def initialize(challenge)
    @challenge = challenge
    @on_each_solution = lambda { |_| }
  end

  def run
    @challenge.solutions.each do |solution|
      results = Language.run_tests @challenge.test_case, solution.code
      correct = ChallengeSolution.correct? results.passed_count, results.failed_count

      solution.update_attributes!({
        passed_tests: results.passed_count,
        failed_tests: results.failed_count,
        log: results.log,
        correct: correct,
      })

      @on_each_solution.call solution
    end
  end

  def on_each_solution(&block)
    @on_each_solution = block
  end
end
