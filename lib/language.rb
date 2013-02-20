# encoding: utf-8

module Language
  extend self

  def course_name
    "Програмиране с Ruby"
  end

  def run
    Dir.mktmpdir do |dir|
      spec_path     = Pathname(dir).join('spec.rb')
      solution_path = Pathname(dir).join('solution.rb')

      open(spec_path, 'w') { |file| file.write @test.encode('utf-8') }
      open(solution_path, 'w') { |file| file.write @solution }

      output = `ruby lib/homework/runner.rb #{spec_path} #{solution_path}`
      json, log = output.split("\nLOG:\n", 2)

      passed_count = results['passed'].try(:count) || 0
      failed_count = results['failed'].try(:count) || 0
      [passed_count, failed_count, log]
    end
  end
end
