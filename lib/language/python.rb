# encoding: utf-8
module Language::Python
  extend self

  def language
    :python
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

