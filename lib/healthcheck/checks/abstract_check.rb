require 'healthcheck'
require 'active_support/inflector'
require 'active_support/core_ext/module/delegation'

module Healthcheck
  module Checks
    class AbstractCheck
      attr_writer :logger
      attr_accessor :paused

      delegate :slug, to: :class

      def ok?
        [true, :paused].include?(result)
      end

      def report
        case result
        when true then :ok
        when :paused then "paused until #{paused}"
        else :unreachable
        end
      end

      def reset
        remove_instance_variable(:@result) if @result
        filter_by_query({})
        true
      end

      def self.slug
        name.to_s.demodulize.underscore.to_sym
      end

      def filter_by_query(query); end

      private

      def logger
        @logger || Healthcheck.configuration.logger
      end

      def result
        unless instance_variable_defined?(:@result)
          @result = paused? ? :paused : perform
        end

        @result
      end

      def paused?
        paused.is_a?(Time) && paused > Time.now.utc
      end

      def perform
        raise NotImplementedError, 'Checks must implement this method'
      end
    end
  end
end
