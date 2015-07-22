require 'healthcheck'
require 'active_support/inflector'

module Healthcheck
  module Checks
    class AbstractCheck
      attr_writer :logger

      def ok?
        result == true
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

      def result
        @result ||= perform
      end

      def perform
        fail NotImplementedError, 'Checks must implement this method'
      end
    end
  end
end
