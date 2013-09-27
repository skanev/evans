# Evans

[![Build Status](https://travis-ci.org/skanev/evans.png?branch=master)](https://travis-ci.org/skanev/evans)

The website for the "Programming with Ruby" course in the Faculty of
Mathematics and Informatics of the Sofia University. That's a really
long way to say "university stuff, all in Bulgarian".

## Requirements

* Ruby 2.0+
* PostgreSQL, preferable 9.0+
* Redis
* ImageMagick or a compatible package (such as GraphicsMagic)

## Development setup

It's a pretty standard Rails application, with the exception of `site.yml`. Steps are as follows:

1. Clone the repository
2. Run `bundle install`
3. Create a `config/database.yml` based on `config/database.yml.example`
4. Create a `config/site.yml` based on `config/site.yml.example`
5. Set up the database with `rake db:create:all db:migrate`
6. Profit!

If you want to get some test data, you can run:

    $ rake fake

This will populate the database with random data and give you credentials to log in.

## Running the tests

You can run the tests with `rake`. However, for completeness' sake:

* `rake spec cucumber` runs the basic test suite
* `rake spec:languages:python` runs the tests for the Python language
* `rake spec:languages` runs the tests for all languages
* `rake spec spec:languages cucumber` runs everything
