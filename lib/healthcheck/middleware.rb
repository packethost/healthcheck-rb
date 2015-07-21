require 'healthcheck'

module Healthcheck
  class Middleware
    def initialize(app, path = :healthcheck)
      @app = app
      @path = path
    end

    def call(env)
      if env['PATH_INFO'] == "/#{@path}"
        NewRelic::Agent.ignore_transaction if defined? NewRelic
        report = Healthcheck::Report.new
        [report.ok? ? 200 : 500, { 'Content-Type' => 'application/json' }, [report.to_json]]
      else
        @app.call(env)
      end
    end
  end
end
