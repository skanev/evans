require 'rubygems'
require 'spork'
 
Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  
  require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
  require 'cucumber/rails'
  require 'cucumber/web/tableish'

  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'

  Capybara.default_selector = :css
  Cucumber::Rails::World.use_transactional_fixtures = true

  ActiveSupport::Dependencies.clear

  Test::Unit.run = true
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  FactoryGirl.factories.clear
  Dir[Rails.root.join("spec/factories.rb")].each {|f| load f}

  Trane::Application.reload_routes!

  load 'Sporkfile.rb' if File.exists?('Sporkfile.rb')

  require 'features/support/another_world.rb'
end
