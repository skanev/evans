require 'tmpdir'
require 'rspec'
require File.expand_path('../../rspec_json_formatter', __FILE__)

if ARGV.count != 2
  puts "USAGE: ruby lib/scripts/#{__FILE__} <test_file> <solution_file>"
  exit(1)
end

test_file     = ARGV[0]
solution_file = ARGV[1]

original_wd = FileUtils.getwd

Dir.mktmpdir do |dir|
  FileUtils.cp test_file,     File.join(dir, 'solution_spec.rb')
  FileUtils.cp solution_file, File.join(dir, 'solution.rb')

  FileUtils.cd dir

  args = %W{
    solution_spec.rb
    --require ./solution
    --format progress
    --out output.txt
    --format JsonFormatter
    --out output.json
  }

  begin
    RSpec::Core::Runner.run(args)
  rescue Exception => e
    File.open('output.txt', 'w') { |f| f.write(e.backtrace.join("\n")) }
    File.open('output.json', 'w') do |f|
      f.write({
        'count'  => 0,
        'passed' => [],
        'failed' => []
      }.to_json)
    end
  end

  FileUtils.cp('output.txt',  File.join(original_wd, 'tmp', 'rspec', 'output.txt'))
  FileUtils.cp('output.json', File.join(original_wd, 'tmp', 'rspec', 'output.json'))
end
