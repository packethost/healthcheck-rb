require 'healthcheck'
require 'json'
require 'active_support/core_ext/hash/transform_values'
require 'active_support/core_ext/enumerable'

module Healthcheck
  class Report
    attr_reader :checks

    def initialize(checks = Healthcheck.configuration.checks)
      @checks = checks.map do |check|
        check.reset
        check.paused = paused_data[check.slug]
        check
      end.index_by(&:slug)
    end

    def ok?
      checks.values.map do |check|
        Thread.new(check, &:ok?)
      end.map(&:value).all?
    end

    def to_json
      checks.transform_values do |check|
        Thread.new(check, &:report)
      end.transform_values(&:value).to_json
    end

    private

    def paused_data
      @paused_data ||= Healthcheck.configuration.paused_checks
    end
  end
end
