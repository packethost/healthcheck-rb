require 'healthcheck'
require 'json'
require 'active_support/inflector'
require 'active_support/core_ext/hash/transform_values'

module Healthcheck
  class Report
    attr_reader :checks

    def initialize(checks = Healthcheck.configuration.checks)
      @checks = checks.map do |check|
        check = initialize_check(check)
        [check.class.slug, check]
      end.to_h
    end

    def ok?
      checks.values.map do |check|
        Thread.new(check) { |c| c.ok? }
      end.map(&:value).all?
    end

    def to_json
      checks.transform_values do |check|
        Thread.new(check) { |c| c.report }
      end.transform_values(&:value).to_json
    end

    private

    def initialize_check(check)
      case check
      when Healthcheck::Checks::AbstractCheck then check
      when Class then check.new
      else check.constantize.new
      end.tap do |c|
        c.reset
        c.paused = paused_data[c.class.slug]
      end
    end

    def paused_data
      @paused_data ||= Healthcheck.configuration.paused_checks
    end
  end
end
