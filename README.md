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

First, we need to configure it.

### Rails

```ruby
# config/initializers/healthcheck.rb

require 'healthcheck/checks/git'
require 'healthcheck/checks/database/active_record'

Healthcheck.configure do |config|
  # The checks that you want to run. Defaults to `[]`.
  config.checks = %w(
    Healthcheck::Checks::Git
    Healthcheck::Checks::Database::ActiveRecord
  )

  # The path our healthcheck will be accessible at. Defaults to '/healthcheck'.
  config.path = '/annie-are-you-ok'

  # Defaults to Rails.logger if you're using Rails, or STDOUT if not.
  config.logger = logger
end
```

### Manually

If you're using Sinatra or something, configure it the same way as above, but
you have to add the middleware yourself:

```ruby
require 'healthcheck/middleware'

use Healthcheck::Middleware, '/annie-are-you-ok' # Path is optional.
```

Or, you could just add it as a rack app at an endpoint of your choosing:

```ruby
require 'healthcheck/application'

run Rack::URLMap.new(
  '/healthcheck' => Healthcheck::Application.new
)
```

Whatever you're using, we gotcha covered.

### Calling the healthcheck endpoint

Once you've set up the healthcheck middleware in your app, you can hit the
endpoint at whatever path you configured:

```
$ curl -i http://example.com/healthcheck

HTTP/1.1 200 OK
Content-Type: application/json
Status: 200 OK
...

{"git":"cc3b4c7","database":"ok"}
```

The healthcheck will return a 200 status if all the checks were successful, and
a 500 if any of them failed. The response body will always be in JSON format,
and will always contain a status message for each of the checks included in the
report.

You can also limit your calls to only certain checks by including a `checks`
parameter in the query string:

```
$ curl -i http://example.com/healthcheck?checks=git

HTTP/1.1 200 OK
Content-Type: application/json
Status: 200 OK
...

{"git":"cc3b4c7"}
```

The `checks` parameter can be either a string or an array
(`checks[]=git&checks=database`) to run multiple checks. A 404 status will be
returned if any of the checks you specify don't exist.

## Checks

There are lots of checks you can use or subclass. [Here's a list of the checks
are that are currently supported](https://github.com/packethost/healthcheck-rb/tree/master/lib/healthcheck/checks). We'll gladly accept pull requests for additional checks, and will continue to add to the existing checks according to the needs of our stack.

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/packethost/healthcheck.
