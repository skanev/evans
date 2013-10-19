module Language::Python
  extend self

  def language
    :python
  end

  def extension
    'py'
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

  def parses?(code)
    TestRunner.with_tmpdir('code.py' => code) do |dir|
      code_path = dir.join('code.py')
      system "python3.3 -m py_compile #{code_path}"
    end
  end

  def run_tests(test, solution)
    TestRunner.with_tmpdir('test.py' => test, 'solution.py' => solution) do |dir|
      test_path = dir.join('test.py')

      results = JSON.parse `python3.3 lib/language/python/runner.py #{test_path}`

      TestRunner::Results.new({
        log: results['log'] || '',
        passed: results['passed'] || [],
        failed: results['failed'] || [],
      })
    end
  end
end

