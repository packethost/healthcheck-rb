require 'healthcheck'
require 'healthcheck/application'

module Healthcheck
  class Middleware
    attr_reader :path

    def initialize(app, path = nil)
      @app = app
      self.path = path || Healthcheck.configuration.path
    end

    def call(env)
      if env['PATH_INFO'] =~ %r{^#{path}($|/)}
        Application.new.call(env)
      else
        @app.call(env)
      end
    end

    def path=(path)
      path = "/#{path}" unless path.start_with?('/')
      @path = path
    end
  end
end
