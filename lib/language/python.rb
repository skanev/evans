# encoding: utf-8
module Language::Python
  extend self

  def language
    :python
  end

  def run_tests(test, solution)
    Dir.mktmpdir do |dir|
      test_path     = Pathname(dir).join('test.py')
      solution_path = Pathname(dir).join('solution.py')

      open(test_path, 'w') { |file| file.write test.encode('utf-8') }
      open(solution_path, 'w') { |file| file.write solution.encode('utf-8') }

      results = JSON.parse `python3.3 lib/homework/runner.py #{test_path}`

      {
        log: results['log'] || '',
        passed: results['passed'] || 0,
        failed: results['failed'] || 0,
      }
    end
  end
end

