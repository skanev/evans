require 'rubygems'
require 'spork'
 
Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

  require 'rspec'

  require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
  require 'cucumber/rails'

  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'

  Capybara.default_selector = :css
  Cucumber::Rails::World.use_transactional_fixtures = true

  ActiveSupport::Dependencies.clear
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  Trane::Application.reload_routes!
  I18n.reload!

  load 'Sporkfile.rb' if File.exists?('Sporkfile.rb')

  World(CustomPaths)
  require './features/support/another_world'
end
