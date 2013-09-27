# Evans

[![Build Status](https://travis-ci.org/skanev/evans.png?branch=master)](https://travis-ci.org/skanev/evans)

The website for the "Programming with Ruby" course in the Faculty of
Mathematics and Informatics of the Sofia University. That's a really
long way to say "university stuff, all in Bulgarian".

## Basic setup

1. Clone the repo and `cd` into the working directory.
2. Make sure you have the Ruby version required by the project. Look in `.ruby-version` for that. You can use `rbenv` or `rvm` for that, it doesn't matter.
3. Run `bundle install`
4. Create a `database.yml`, based on its example file and make sure the connection settings are working.
5. Create a `site.yml`, based ont its example.
6. Run `bundle exec rake db:create:all`
7. Run `bundle exec rake db:migrate`
8. That's it, the site should now be working. You can check it out by starting a server with `bundle exec rails server` and visiting [http://localhost:3000/](http://localhost:3000/)
9. You'll probably need an admin user. You can create one via the Rails console, `bundle exec rails console`, with a code similar to this:

		User.create({
		  full_name: 'Charlie Root',
		  name: 'Charlie Root',
		  faculty_number: '_charlie',
		  email: 'charlie@example.org',
		  password: 'foobar',
		  password_confirmation: 'foobar',
		  admin: true,
		}, without_protection: true)

	And now you should be able to login with `charlie@example.org` and `foobar` as a password.

## External dependencies

* ImageMagick or a compatible package such as GraphicsMagic needs to be installed on the system. Its binaries `convert` and `identify` must be reachable via `$PATH`.
* A PostgreSQL database.
* An instance of `redis-server` (used by the queue system, [Sidekiq](https://github.com/mperham/sidekiq)).

## Running the tests

* Make sure you've executed `bundle exec rake db:migrate RAILS_ENV=test`.
* Run `bundle exec rspec spec && bundle exec rake cucumber`.
