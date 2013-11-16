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

  def parsing?(code)
    return true if code.empty?
    TempDir.for('code.go' => code) do |dir|
      code_path = dir.join('code.go')
      result = nil

      FileUtils.cd(dir) do
        result = `gofmt -d #{code_path} 2>&1`
      end

      result.strip.empty?
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
