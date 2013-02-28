class TestRunner
  attr_reader :passed_count, :failures_count, :log

  def initialize(test, solution)
    @test     = test
    @solution = solution
  end

  class << self
    def run(test, solution)
      runner = new(test, solution)
      runner.run
      [runner.passed_count, runner.failures_count, runner.log]
    end
  end

  def run
    result = Language.run_tests(@test, @solution)
    @log            = result[:log]
    @passed_count   = result[:passed]
    @failures_count = result[:failed]
  end
end
