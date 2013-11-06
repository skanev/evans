module Language::Ruby
  extend self

  def language
    :ruby
  end

  def extension
    'rb'
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

      output = `ruby lib/language/ruby/runner.rb #{spec_path} #{solution_path}`
      json, log = output.split("\nLOG:\n", 2)
      results = JSON.parse json

      TestResults.new({
        log: log,
        passed: results['passed'] || [],
        failed: results['failed'] || [],
      })
    end
  end
end
