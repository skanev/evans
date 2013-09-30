require 'rubygems'
require 'spork'
require 'simplecov'
require 'coveralls'

SimpleCov.command_name 'Cucumber Features' if ENV['COVERAGE']
Coveralls.wear! 'rails' if ENV['TRAVIS']

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"

  # Don't let Devise load the User model early
  require 'rails/application'
  Spork.trap_method Rails::Application::RoutesReloader, :reload!

  require 'rspec'

  require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
  require 'cucumber/rails'

  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'


  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

  Capybara.default_selector = :css
  Cucumber::Rails::World.use_transactional_fixtures = true

  World(FactoryGirl::Syntax::Methods)

  ActiveRecord::Base.remove_connection
end

Spork.each_run do
  ActiveRecord::Base.establish_connection

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  Trane::Application.reload_routes!
  I18n.reload!
  FactoryGirl.reload

  load 'Sporkfile.rb' if File.exists?('Sporkfile.rb')

  World(CustomPaths)
  require './features/support/another_world'
  require 'sidekiq/testing'
end
