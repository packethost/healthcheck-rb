# Healthcheck

[![Build Status](https://travis-ci.org/packethost/healthcheck-rb.svg)](https://travis-ci.org/packethost/healthcheck-rb)

> Another issue is If the components do not compose cleanly, then all you are doing is shifting complexity from inside a component to the connections between components.
>
> -- <cite>Martin Fowler & James Lewis, [Microservices](http://martinfowler.com/articles/microservices.html)</cite>

Yeah, our platform is built on microservices. And docker. Sometimes an
individual app or service may be responding to simple pings, but its
connections to other apps in the system are broken. This is a library for
writing checks against those external services (an HTTP API, a database,
memcache, whatever) that attempts to give a _comprehensive_ answer to the
question "is the application up?".

All of this is wrapped in an endpoint that you can ping and hook up to your
monitoring and alerting. Put that in your Zabbix and smoke it.

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

## Checks

There are lots of checks you can use or subclass. [Here's a list of the checks
are that are currently supported](https://github.com/packethost/healthcheck-rb/tree/master/lib/healthcheck/checks). We'll gladly accept pull requests for additional checks, and will continue to add to the existing checks according to the needs of our stack.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/packethost/healthcheck.
