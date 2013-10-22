begin
  require 'rspec-rails'

  namespace :spec do
    namespace :languages do
      languages = %w(Python Clojure Go Ruby)

      languages.each do |language|
        desc "Runs the specs that integrate with #{language}"
        RSpec::Core::RakeTask.new(:"#{language.downcase}") do |t|
          t.rspec_opts = "--tag #{language.downcase}"
        end
      end

      desc 'Runs the specs for all languages'
      RSpec::Core::RakeTask.new(:all) do |t|
        t.rspec_opts = languages.map { |lang| "--tag #{lang.downcase}" }.join(' ')
      end
    end

    desc 'Runs the specs for all languages'
    task languages: 'languages:all'
  end
rescue LoadError
  desc 'spec rake tasks not available in this environment'
  task :spec do
    abort "The spec tasks are not available in the #{Rails.env} environment."
  end
end
