Trane::Application.configure do
  Rails.application.load_site_yml_into_config

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Use https://github.com/ryanb/letter_opener to open
  # emails locally in the browser instead of sending them
  config.action_mailer.delivery_method = :letter_opener

  # Set a default host that will be used in all mailers
  config.action_mailer.default_url_options = {:host => 'trane.example.org'}

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Site configuration
  config.pepper = 'cc1a01a066c8130b357fb77069dcae04b459a4ec8950f6245bcab82487832b4a4ec0c093be4c84aa6cfd934c41fd217cfb55c4af19704ca95b29e8140e9dfbb9'
  config.secret_token = '7a3a2bfc22da8bb0cdb62800d63afdff107ac85c53724d5e953d19171f89270f3da861793621c29cb2fab1d627d59d89cb08a1b69db7564a542812ad12734290'
  config.secret_key_base = '2b7037bbbcdcc81b51504033ff612333147b4cb1701b86cb0f2fe619dd048823fc607e53c391d7605eb726bd112434e06fd2985c021fdcb4aa2b5e04385f1dd11'

  # Eager loading
  config.eager_load = false
end

silence_warnings do
  require 'pry'
  IRB = Pry
end
