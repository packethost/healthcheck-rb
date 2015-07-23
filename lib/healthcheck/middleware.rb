require 'healthcheck'
require 'healthcheck/application'

module Healthcheck
  class Middleware
    def initialize(app, path = nil)
      @app = app
      @path = path
    end

    def call(env)
      if env['PATH_INFO'] == path
        Application.new.call(env)
      else
        @app.call(env)
      end
    end

    private

    def path
      @path || Healthcheck.configuration.path
    end
  end
end
