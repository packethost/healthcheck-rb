require 'healthcheck'
require 'rack/request'
require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/object/blank'

module Healthcheck
  class Application
    HEADERS = { 'Content-Type' => 'application/json' }.freeze

    def call(env)
      NewRelic::Agent.ignore_transaction if defined? NewRelic

      request = Rack::Request.new(env)
      report = report_from_request(request)
      [report.ok? ? 200 : 500, HEADERS, [report.to_json]]
    rescue CheckNotFound => ex
      [404, HEADERS, [{ errors: [ex.message] }.to_json]]
    end

    private

    def report_from_request(request)
      checks = checks_from_query(request.GET)
      Healthcheck::Report.new(checks)
    end

    def checks_from_query(query)
      check_slugs = Array.wrap(query['checks']).uniq.reject(&:blank?).map(&:to_sym)
      all_checks = Healthcheck.configuration.checks

      if check_slugs.empty?
        all_checks
      else
        filter_checks(all_checks, check_slugs)
      end
    end

    def filter_checks(checks, slugs)
      filtered = slugs
                 .map { |slug| [slug, checks.find { |check| check.slug == slug }] }
                 .to_h

      not_found = filtered.select { |_, v| v.nil? }.keys
      raise CheckNotFound, "Check(s) #{not_found.to_sentence} not found" unless not_found.empty?

      filtered.values
    end
  end

  class CheckNotFound < RuntimeError; end
end
