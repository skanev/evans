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

  def run_tests(test, solution)
    TestRunner.with_tmpdir('solution_test.go' => test, 'solution.go' => solution) do |dir|
      test_path = dir.join('solution_test.go')

      results = JSON.parse(`go run lib/language/go/runner.go -- #{test_path}`.strip)

      TestRunner::Results.new({
        log:    results['Log'] || '',
        passed: results['Passed'] || [],
        failed: results['Failed'] || [],
      })
    end
  end
end
