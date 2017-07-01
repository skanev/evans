module Language::Rust
  extend self

  def language
    :rust
  end

  def extension
    'rs'
  end

  def can_lint?
    false
  end

  def test_file_pattern
    '*_test.rs'
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
    TempDir.for('code.rs' => code) do |dir|
      code_path = dir.join('code.rs')
      system "rustc #{code_path} > /dev/null 2>&1"
    end
  end

  def run_tests(test, solution)
    TempDir.for('solution_test.rs' => test, 'solution.rs' => solution) do |dir|
      results = nil

      FileUtils.cd(dir) do
        results = `rustc --test solution_test.rs && ./solution_test`.strip.split("\n")
      end

      TestResults.new({
        log:    results,
        passed: results.grep(/^test solution_test::[a-z_]+ ... ok$/),
        failed: results.grep(/^test solution_test::[a-z_]+ ... FAILED$/),
      })
    end
  end
end
