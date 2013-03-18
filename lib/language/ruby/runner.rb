require 'tmpdir'
require 'pathname'

if ARGV.count != 2
  puts "USAGE: ruby #{__FILE__} <test_file> <solution_file>"
  exit(1)
end

rspec_bin      = `which rspec`.chomp
spec_path      = File.expand_path ARGV[0]
solution_path  = File.expand_path ARGV[1]
formatter_path = File.expand_path 'json_formatter', File.dirname(__FILE__)
timeout_path   = File.expand_path 'run_with_timeout', File.dirname(__FILE__)

Dir.mktmpdir do |dir|
  log_path  = Pathname(dir).join('log.txt')
  json_path = Pathname(dir).join('results.json')

  system rspec_bin,
    spec_path,
    '--require', formatter_path,
    '--require', timeout_path,
    '--require', solution_path,
    '--format',  'JsonFormatter',
    '--out',     json_path.to_s,
    '--format',  'progress',
    :err => log_path.to_s,
    :out => log_path.to_s

  if json_path.exist? and not json_path.read.empty?
    puts json_path.read
  else
    puts "{}"
  end

  puts "LOG:"
  puts log_path.read
end
