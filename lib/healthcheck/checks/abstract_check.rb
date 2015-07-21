require 'healthcheck'
require 'active_support/inflector'

module Healthcheck
  module Checks
    class AbstractCheck
      attr_writer :logger

      def ok?
        true
      end

      def report
        ok? ? :ok : :unreachable
      end

      def self.slug
        name.to_s.demodulize.downcase.underscore.to_sym
      end

      private

      def logger
        @logger || Healthcheck.configuration.logger
      end
    end
  end
end
