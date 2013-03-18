class TestRunner
  attr_reader :passed_count, :failures_count, :log

  class Results
    attr_accessor :passed, :failed, :log

    def initialize(attributes = {})
      attributes.each do |key, value|
        send "#{key}=", value
      end
    end

    def passed_count
      passed.count
    end

    def failed_count
      failed.count
    end
  end

  def initialize(test, solution)
    @test     = test
    @solution = solution
  end

  class << self
    def run(test, solution)
      runner = new(test, solution)
      runner.run

      TestResults.new({
        passed: runner.passed_count,
        failed: runner.failures_count,
        log: runner.log,
      })
    end

    def with_tmpdir(files)
      Dir.mktmpdir do |dir|
        dir_path = Pathname(dir)

        files.each do |name, contents|
          file_path = dir_path.join(name)
          open(file_path, 'w') { |file| file.write contents.encode('utf-8') }
        end

        yield dir_path
      end
    end
  end

  def run
    result = Language.run_tests(@test, @solution)

    @log            = result.log
    @passed_count   = result.passed_count
    @failures_count = result.failed_count
  end
end
