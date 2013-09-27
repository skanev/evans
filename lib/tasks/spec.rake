namespace :spec do
  namespace :languages do
    languages = %w(Python Clojure)

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
