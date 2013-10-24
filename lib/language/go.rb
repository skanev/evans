module Language::Go
  extend self

  def language
    :go
  end

  def extension
    'go'
  end

  def solution_dump(attributes)
    <<-END
// #{attributes[:name]}
// #{attributes[:faculty_number]}
// #{attributes[:url]}

#{attributes[:code]}

// Log output
// ----------
#{attributes[:log].lines.map { |line| "// #{line}".strip }.join("\n")}
    END
  end

  def parses?(code)
    return true if code.empty?
    TempDir.for('code.go' => code) do |dir|
      code_path = dir.join('code.go')
      result = nil

      FileUtils.cd(dir) do
        result = system "go build #{code_path} > /dev/null 2>&1"
      end

      result
    end
  end

  def run_tests(test, solution)
    TempDir.for('solution_test.go' => test, 'solution.go' => solution) do |dir|
      runner_path = File.expand_path("lib/language/go/runner.go")
      results     = nil

      FileUtils.cd(dir) do
        results = JSON.parse(`go run #{runner_path} -- solution_test.go`.strip)
      end

      TestResults.new({
        log:    results['Log'] || '',
        passed: results['Passed'] || [],
        failed: results['Failed'] || [],
      })
    end
  end
end
