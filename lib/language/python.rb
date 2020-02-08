module Language::Python
  extend self

  def language
    :python
  end

  def extension
    'py'
  end

  def can_lint?
    false
  end

  def test_file_pattern
    'test.py'
  end

  def solution_dump(attributes)
    <<-END
# #{attributes[:name]}
# #{attributes[:faculty_number]}
# #{attributes[:url]}

#{attributes[:code]}

# Log output
# ----------
#{attributes[:log].lines.map { |line| "# #{line}".strip }.join("\n")}
    END
  end

  def parsing?(code)
    TempDir.for('code.py' => code) do |dir|
      code_path = dir.join('code.py')
      system "python3.8 -m py_compile #{code_path} > /dev/null 2>&1"
    end
  end

  def run_tests(test, solution)
    TempDir.for('test.py' => test, 'solution.py' => solution) do |dir|
      test_path   = dir.join('test.py')
      runner_path = File.expand_path("python/runner.py", File.dirname(__FILE__))

      results = JSON.parse `python3.8 #{runner_path} #{test_path}`

      TestResults.new({
        log: results['log'] || '',
        passed: results['passed'] || [],
        failed: results['failed'] || [],
      })
    end
  end
end

