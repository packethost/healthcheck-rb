require 'logger'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/try'

module Healthcheck
  class Configuration
    CONFIGURABLE_OPTIONS = {

      # Defines a logger instance to use when logging healthcheck failures.
      # Must be an instance of `Logger`, defaults to stdout.
      logger: nil,

      # An array of checks to perform. Each item in the array can be an
      # instantiated object, a class, or a class name as a string.
      checks: [],

      # The path we want or middleware to answer to.
      path: '/healthcheck',

      # Data about sleep timers that may be active for any of the healthchecks.
      # Must be a proc that returns a hash that has a nesting structure similar
      # to that returned by the healthcheck, where values are DateTime objects
      # or nil.
      paused_checks: nil
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

    def paused_checks
      (@paused_checks.try(:call) || {}).symbolize_keys
    end
  end
end
