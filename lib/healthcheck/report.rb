require 'healthcheck'
require 'json'
require 'active_support/inflector'
require 'active_support/core_ext/hash/transform_values'

module Healthcheck
  class Report
    attr_reader :reports

    def initialize(checks = Healthcheck.configuration.checks)
      @reports = checks.map do |check|
        check = case check
                when Healthcheck::Checks::AbstractCheck then check
                when Class then check.new
                when Symbol
                  require "healthcheck/checks/#{check}"
                  "Healthcheck::Checks::#{check.to_s.classify}".constantize.new
                else check.constantize.new
                end
        [check.class.slug, check]
      end.to_h
    end

    def ok?
      reports.values.all?(&:ok?)
    end

    def to_json
      reports.transform_values(&:report).to_json
    end
  end
end
