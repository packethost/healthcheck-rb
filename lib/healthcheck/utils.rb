require 'active_support/inflector'
require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Utils
    def self.slug_from_check(check)
      case check
      when Healthcheck::Checks::AbstractCheck then check.class
      when Class then check
      else check.constantize
      end.slug
    end
  end
end
