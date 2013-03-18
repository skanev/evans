# encoding: utf-8
module Language::Clojure
  extend self

  def language
    :clojure
  end

  def run_tests(test, solution)
    runner = Rails.root.join('lib/language/clojure/runner.clj').read
    TestRunner.with_tmpdir('test.clj' => test, 'solution.clj' => solution, 'runner.clj' => runner) do |dir|
      Dir.chdir(dir) do
        result = `clj runner.clj`
        passed_line, failed_line, log = result.split("\n", 3)

        passed = passed_line[/^Passed: (.*)$/, 1].split(';')
        failed = failed_line[/^Failed: (.*)$/, 1].split(';')

        return TestRunner::Results.new({
          passed: passed,
          failed: failed,
          log: log,
        })
      end
      spec_path     = dir.join('spec.rb')
      solution_path = dir.join('solution.rb')

      output = `ruby lib/language/ruby/runner.rb #{spec_path} #{solution_path}`
      json, log = output.split("\nLOG:\n", 2)
      results = JSON.parse json

      TestRunner::Results.new({
        log: log,
        passed: results['passed'] || [],
        failed: results['failed'] || [],
      })
    end
  end
end
