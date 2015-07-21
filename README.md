# Healthcheck

A library for reporting on the health of your ruby app. Useful for providing
a route for Zabbix or whatever to ping.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'healthcheck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install healthcheck

## Usage

First, we need to set up some checks to run. Healthcheck comes with a couple,
but you can easily add your own.

```ruby
# config/initializers/healthcheck.rb

require 'healthcheck/checks/git'
require 'healthcheck/checks/database/active_record'

Healthcheck.configure do |config|
  config.checks = %w(
    Healthcheck::Checks::Git
    Healthcheck::Checks::Database::ActiveRecord
  )
end
```

That's all well and good, but we need to set up the middleware so that we have
a route to ping:

```ruby
# config/application.rb

module MyApp
  class Application < Rails::Application
    require 'healthcheck/middleware'

    # Optionally specify a path (defaults to /healthcheck).
    config.middleware.insert_before 0, Healthcheck::Middleware, '/annie-are-you-ok'
  end
end
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/packethost/healthcheck.
