module Language::Clojure
  extend self

  def language
    :clojure
  end

  def extension
    'clj'
  end

  def solution_dump(attributes)
    <<-END
;;; #{attributes[:name]}
;;; #{attributes[:faculty_number]}
;;; #{attributes[:url]}

#{attributes[:code]}

;; Log output
;; ----------
#{attributes[:log].lines.map { |line| ";; #{line}".strip }.join("\n")}
    END
  end

  def run_tests(test, solution)
    runner = Rails.root.join('lib/language/clojure/runner.clj').read

    TestRunner.with_tmpdir('test.clj' => test, 'solution.clj' => solution, 'runner.clj' => runner) do |dir|
      Dir.chdir(dir) do
        result = `clojure runner.clj`
        passed_line, failed_line, log = result.split("\n", 3)

        passed = passed_line[/^Passed: (.*)$/, 1].split(';')
        failed = failed_line[/^Failed: (.*)$/, 1].split(';')

        TestRunner::Results.new({
          passed: passed,
          failed: failed,
          log: log,
        })
      end
    end
  end
end
