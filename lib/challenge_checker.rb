class ChallengeChecker
  def initialize(challenge)
    @challenge = challenge
    @on_each_solution = lambda { |_| }
  end

  def run
    @challenge.solutions.each do |solution|
      passed, failed, log = TestRunner.run @challenge.test_case, solution.code
      correct = ChallengeSolution.score passed, failed

      solution.update_attributes! passed_tests: passed, failed_tests: failed, log: log, correct: correct

      @on_each_solution.call solution
    end
  end

  def on_each_solution(&block)
    @on_each_solution = block
  end
end
