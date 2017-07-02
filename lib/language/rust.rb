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
      script_path = Rails.root.join('lib/language/rust/syntax_check.rb')
      code_path   = dir.join('code.rs')

      system script_path.to_s, code_path.to_s
    end
  end

  def run_tests(test, solution)
    TempDir.for('solution_test.rs' => test, 'solution.rs' => solution) do |dir|
      results = nil

      FileUtils.cd(dir) do
        results = `rustc --test solution_test.rs && ./solution_test`.strip
      end

      TestResults.new({
        log:    results,
        passed: results.split("\n").grep(/^test solution_test::[a-z_]+ ... ok$/),
        failed: results.split("\n").grep(/^test solution_test::[a-z_]+ ... FAILED$/),
      })
    end
  end
end
