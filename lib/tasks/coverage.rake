desc 'Generate test coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].invoke
  Rake::Task['cucumber'].invoke
end
