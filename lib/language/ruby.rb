# encoding: utf-8
module Language::Ruby
  extend self

  def language
    :ruby
  end

  def course_name
    "Програмиране с Ruby"
  end

  def email
    'fmi@ruby.bg'
  end

  def domain
    'fmi.ruby.bg'
  end

  def run_tests(test, solution)
    Dir.mktmpdir do |dir|
      spec_path     = Pathname(dir).join('spec.rb')
      solution_path = Pathname(dir).join('solution.rb')

      open(spec_path, 'w') { |file| file.write test.encode('utf-8') }
      open(solution_path, 'w') { |file| file.write solution }

      output = `ruby lib/homework/runner.rb #{spec_path} #{solution_path}`
      json, log = output.split("\nLOG:\n", 2)
      results = JSON.parse json

      {
        log: log,
        passed: results['passed'].try(:count) || 0,
        failed: results['failed'].try(:count) || 0,
      }
    end
  end
end
