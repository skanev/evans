Trane::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection = false

  # Set a default host that will be used in all mailers
  config.action_mailer.default_url_options = {:host => 'trane.example.org'}

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  #config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # Site configuration
  config.language = :ruby
  config.course_id = 'evans-test'
  config.course_name = 'A Test Evans instance'
  config.course_email = 'evans@example.org'
  config.course_domain = 'evans.example.org'
  config.previous_instances = []
  config.pepper = 'cc1a01a066c8130b357fb77069dcae04b459a4ec8950f6245bcab82487832b4a4ec0c093be4c84aa6cfd934c41fd217cfb55c4af19704ca95b29e8140e9dfbb9'
  config.secret_token = '7a3a2bfc22da8bb0cdb62800d63afdff107ac85c53724d5e953d19171f89270f3da861793621c29cb2fab1d627d59d89cb08a1b69db7564a542812ad12734290'
  config.secret_key_base = '2b7037bbbcdcc81b51504033ff612333147b4cb1701b86cb0f2fe619dd048823fc607e53c391d7605eb726bd112434e06fd2985c021fdcb4aa2b5e04385f1dd11'

  # Eager load
  config.eager_load = false
end
