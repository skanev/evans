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
    'test_*.rs'
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
    cargo_toml = <<~EOF
      [package]
      name = "solution"
      version = "0.1.0"
      authors = ["Rust Course <fmi@rust-lang.bg>"]

      [dependencies]
    EOF

    test = <<~EOF
      mod solution_test {
        #{test}
      }
    EOF

    TempDir.for({
      'solution/src/lib.rs'             => solution,
      'solution/tests/solution_test.rs' => test,
      'solution/Cargo.toml'             => cargo_toml,
    }) do |dir|
      results = nil

      FileUtils.cd(dir.join('solution')) do
        results = `cargo test 2>&1`.strip
      end

      TestResults.new({
        log:    results,
        passed: results.split("\n").grep(/^test solution_test::test_[a-z0-9_]+ ... ok$/),
        failed: results.split("\n").grep(/^test solution_test::test_[a-z0-9_]+ ... FAILED$/),
      })
    end
  end
end
