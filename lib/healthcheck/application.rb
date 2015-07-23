require 'healthcheck'

module Healthcheck
  class Application
    def call(_env)
      NewRelic::Agent.ignore_transaction if defined? NewRelic
      report = Healthcheck::Report.new
      [report.ok? ? 200 : 500, { 'Content-Type' => 'application/json' }, [report.to_json]]
    end
  end
end
