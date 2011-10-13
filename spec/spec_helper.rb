require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  ActiveSupport::Dependencies.clear
end

Spork.each_run do
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  FactoryGirl.factories.clear
  Dir[Rails.root.join("spec/factories.rb")].each {|f| load f}

  Trane::Application.reload_routes!

  load 'Sporkfile.rb' if File.exists?('Sporkfile.rb')

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.include Support::GeneralHelpers
    config.include Support::ModelHelpers, :type => :model
    config.include Support::ControllerHelpers, :type => :controller
  end
end
