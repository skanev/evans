class TestRunner
  attr_reader :passed_count, :failures_count, :results, :log

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
    Dir.mktmpdir do |dir|
      spec_path     = Pathname(dir).join('spec.rb')
      solution_path = Pathname(dir).join('solution.rb')

      open(spec_path, 'w') { |file| file.write @test.encode('utf-8') }
      open(solution_path, 'w') { |file| file.write @solution }

      output = `ruby lib/homework/runner.rb #{spec_path} #{solution_path}`
      json, log = output.split("\nLOG:\n", 2)

      @log            = log
      @results        = JSON.parse json
      @passed_count   = results['passed'].try(:count) || 0
      @failures_count = results['failed'].try(:count) || 0
    end
  end
end
