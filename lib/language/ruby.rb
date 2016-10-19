module Language::Ruby
  extend self

  def language
    :ruby
  end

  def extension
    'rb'
  end

  def can_lint?
    true
  end

  def test_file_pattern
    'spec'
  end

  def solution_dump(attributes)
    <<-END
# #{attributes[:name]}
# #{attributes[:faculty_number]}
# #{attributes[:url]}

#{attributes[:code]}

__END__
Log output
----------
#{attributes[:log]}
    END
  end

  def parsing?(code)
    TempDir.for('code.rb' => code) do |dir|
      code_path = dir.join('code.rb')
      system "ruby -c #{code_path} > /dev/null 2>&1"
    end
  end

  def run_tests(test, solution)
    TempDir.for('spec.rb' => test, 'solution.rb' => solution) do |dir|
      spec_path     = dir.join('spec.rb')
      solution_path = dir.join('solution.rb')
      runner_path   = File.expand_path("ruby/runner.rb", File.dirname(__FILE__))

      output = `ruby #{runner_path} #{spec_path} #{solution_path}`
      json, log = output.split("\nLOG:\n", 2)
      results = JSON.parse json

      TestResults.new({
        log: log,
        passed: results['passed'] || [],
        failed: results['failed'] || [],
      })
    end
  end

  def lint(code, additional_restrictions = {})
    base_config_location = Rails.application.config.rubocop_config_location

    RubyLinter.new(2.3, base_config_location, additional_restrictions).lint(code)
  end
end
