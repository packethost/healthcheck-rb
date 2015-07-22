require 'healthcheck/version'
require 'healthcheck/configuration'
require 'healthcheck/report'
require 'healthcheck/checks/abstract_check'
require 'active_support/core_ext/module/attribute_accessors'

module Healthcheck
  class << self
    def configure(&_blk)
      yield(configuration)
      configuration
    end

    def configuration
      @_configuration ||= Configuration.new
    end

    def reset_configuration!
      @_configuration = nil
    end
  end
end
