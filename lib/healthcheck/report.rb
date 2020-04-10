require 'healthcheck'
require 'json'
require 'active_support/inflector'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/hash/transform_values'

module Healthcheck
  class Report
    attr_reader :checks

    def initialize(checks = Healthcheck.configuration.checks, query = nil)
      @checks = checks.map { |check| initialize_check(check, query) }
                      .index_by(&:slug)
    end

    def ok?
      checks.values.map do |check|
        Thread.new(check, &:ok?)
      end.map(&:value).all?
    end

    def to_json(_ = nil)
      checks.transform_values do |check|
        Thread.new(check, &:report)
      end.transform_values(&:value).to_json
    end

    private

    def initialize_check(check, query)
      case check
      when Healthcheck::Checks::AbstractCheck then check
      when Class then check.new
      else check.constantize.new
      end.tap do |c|
        c.reset
        c.paused = paused_data[c.class.slug]
        c.filter_by_query(query) unless query.nil?
      end
    end

    def paused_data
      @paused_data ||= Healthcheck.configuration.paused_checks
    end
  end
end
