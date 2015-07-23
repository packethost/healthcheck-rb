require 'logger'

module Healthcheck
  class Configuration
    CONFIGURABLE_OPTIONS = {
      logger: nil,
      checks: [],
      path: '/healthcheck'
    }.freeze

    attr_accessor(*CONFIGURABLE_OPTIONS.keys)

    def initialize
      CONFIGURABLE_OPTIONS.each_pair do |attribute, default|
        instance_variable_set(:"@#{attribute}", default)
      end
    end

    def logger
      @logger || ::Logger.new(STDOUT)
    end
  end
end
