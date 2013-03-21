# encoding: utf-8
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

  def run_tests(test, solution)
    TestRunner.with_tmpdir('spec.rb' => test, 'solution.rb' => solution) do |dir|
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
