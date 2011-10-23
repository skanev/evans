require 'fileutils'

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
    temp_dir = Rails.root.join('tmp', 'rspec')
    FileUtils.mkdir_p temp_dir unless File.exist?(temp_dir)

    test_file     = Rails.root.join('tmp', 'rspec', 'test.rb').to_s
    solution_file = Rails.root.join('tmp', 'rspec', 'solution.rb').to_s

    txt_result_file  = Rails.root.join('tmp', 'rspec', 'output.txt')
    json_result_file = Rails.root.join('tmp', 'rspec', 'output.json')

    File.open(test_file, 'w')     { |f| f.write(@test) }
    File.open(solution_file, 'w') { |f| f.write(@solution) }

    `ruby lib/scripts/rspec_runner.rb #{test_file} #{solution_file} 2>&1`

    unless File.exists?(txt_result_file) and File.exists?(json_result_file)
      raise "RSpec runner script not working properly, please check it out."
    end

    @results        = JSON.parse(File.read(json_result_file))
    @log            = File.read(txt_result_file).strip
    @passed_count   = results['passed'].count
    @failures_count = results['failed'].count
  end
end
