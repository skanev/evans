desc 'Generate test coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].invoke
  Rake::Task['cucumber'].invoke
  Launchy::Browser.run('coverage/index.html')
end
