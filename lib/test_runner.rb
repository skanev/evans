require 'open3'

class TestRunner
  attr_reader :test_path, :code
  attr_reader :passed_count, :failures_count, :log

  def initialize(test_path, code)
    @test_path = test_path
    @code = code
  end

  def run
    ENV['PYTHONPATH'] = Rails.root.join("python")
    solution_path = make_temp_file(@code)

    Open3.popen3("python3.2", test_path, solution_path) do |stdin, stdout, stderr|
      load_log stdout.read + stderr.read
    end

    self
  end

  private

  def make_temp_file(code)
    file = Tempfile.new('solution')
    file.write code
    file.close
    file.path
  end

  def load_log(output)
    if /\A(\d+) (\d+)\n/ =~ output
      @passed_count, @failures_count = [$1, $2].map(&:to_i)
      @log = $'
    else
      @passed_count, @failures_count = 0, 0, 0
      @log = output
    end
  end
end
