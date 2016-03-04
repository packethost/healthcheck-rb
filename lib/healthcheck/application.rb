require 'healthcheck'
require 'rack/request'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/object/blank'

module Healthcheck
  class Application
    FILTERS = %w(only except).freeze
    HEADERS = { 'Content-Type' => 'application/json' }.freeze

    def call(env)
      NewRelic::Agent.ignore_transaction if defined? NewRelic

      request = Rack::Request.new(env)
      report = report_from_request(request)
      [report.ok? ? 200 : 500, HEADERS.dup, [report.to_json]]
    end

    private

    def report_from_request(request)
      checks = filter_checks(Healthcheck.configuration.checks, request.GET)
      Healthcheck::Report.new(checks)
    end

    def filter_checks(checks, query)
      only, except = filters_from_query(query)

      filtered = checks.dup
      filtered.select! { |check| only.include?(check.slug) } unless only.empty?
      filtered.reject! { |check| except.include?(check.slug) }
      filtered
    end

    def filters_from_query(query)
      FILTERS.map do |param|
        Array.wrap(query[param]).uniq.reject(&:blank?).map(&:to_sym)
      end
    end
  end
end
