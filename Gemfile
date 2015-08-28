source 'http://rubygems.org'

gem 'rails', '~> 4.0.0'
gem 'pg'
gem 'devise'
gem 'devise-encryptable'
gem 'simple_form'
gem 'haml'
gem 'will_paginate'
gem 'carrierwave'
gem 'mini_magick'
gem 'draper'

gem 'protected_attributes', '~> 1.0.0'
gem 'rails-observers'

gem 'skeptic'

gem 'spork-rails'

gem 'rails_autolink', '>= 1.1.5'
gem 'rdiscount'
gem 'sanitize', '~> 2.0'
gem 'coderay'

gem 'jquery-rails'
gem 'underscore-rails'

# Sidekiq and its dependencies
gem 'sidekiq', '< 3'
gem 'slim'
gem 'sinatra', require: false

group :production do
  gem 'exception_notification'
end

group :assets do
  gem 'sass-rails', '~> 4.0'
  gem 'sass', '~> 3.2.0'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
  gem 'turbo-sprockets-rails3'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.14'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  gem 'capistrano', '~> 2.8'
  gem 'pry'
  gem 'letter_opener'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-sass', require: false
end

group :test do
  gem 'cucumber', '~> 1.2'
  gem 'cucumber-rails', require: false
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'webrat'
  gem 'email_spec'
  gem 'simplecov'
  gem 'coveralls', require: false
  gem 'test-unit'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
end

group :tasks do
  gem 'rspec'
end
