source 'http://rubygems.org'

gem 'rails', '4.2.11.3'
gem 'rake', '< 11.0'

gem 'pg', '~> 0.15'
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

gem 'rubocop'

gem 'spork-rails'

gem 'rails_autolink', '>= 1.1.5'
gem 'rdiscount'
gem 'sanitize', '~> 2.0'
gem 'rouge'
gem 'diff-lcs'

gem 'jquery-rails'
gem 'underscore-rails'

# Sidekiq and its dependencies
gem 'sidekiq', '< 3'
gem 'slim'
gem 'sinatra', require: false

# Backwards-compatibility for Ruby 2.5 and old Rails 4.x
# See https://stackoverflow.com/a/60491254/75715
gem 'bigdecimal', '1.3.5'

group :production do
  gem 'exception_notification'
end

group :assets do
  gem 'sass-rails', '~> 4.0'
  gem 'sass', '~> 3.2.0'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1.0'
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
  gem 'rspec', '3.1'
end
