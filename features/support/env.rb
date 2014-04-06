ENV["RAILS_ENV"] ||= "test"

require 'rubygems'
require 'simplecov'
require 'coveralls'

SimpleCov.command_name 'Cucumber Features' if ENV['COVERAGE']
Coveralls.wear! 'rails'                    if ENV['TRAVIS']

require 'rails/application'
require 'rspec'

require 'cucumber/formatter/unicode'
require 'cucumber/rails'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

Capybara.default_selector = :css
Cucumber::Rails::World.use_transactional_fixtures = true

World(FactoryGirl::Syntax::Methods)

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Trane::Application.reload_routes!
I18n.reload!
FactoryGirl.reload

World(CustomPaths)
require './features/support/another_world'
require 'sidekiq/testing'
