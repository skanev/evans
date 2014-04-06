ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require 'simplecov'
require 'coveralls'

require File.expand_path("../../config/environment", __FILE__)
require 'rails/application'
require 'rspec/rails'
require 'sidekiq/testing'

SimpleCov.command_name 'RSpec' if ENV['COVERAGE']
Coveralls.wear! 'rails'        if ENV['TRAVIS']

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

FactoryGirl.reload
Trane::Application.reload_routes!

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.filter_run_excluding python: true, clojure: true, go: true, ruby: true

  config.include FactoryGirl::Syntax::Methods
  config.include Support::GeneralHelpers
  config.include Support::ModelHelpers,      type: :model
  config.include Support::ControllerHelpers, type: :controller
  config.include Support::ViewHelpers,       type: :view
  config.include EmailSpec::Helpers,         type: :mailer
  config.include EmailSpec::Matchers,        type: :mailer
  config.include CustomPaths,                type: :mailer
end
