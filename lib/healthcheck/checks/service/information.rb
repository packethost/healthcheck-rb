require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    module Service
      class Information < AbstractCheck
        def initialize(information = nil)
          @information = information
        end

        def self.slug
          :service
        end

        def ok?
          paused? ? :paused : true
        end

        def report
          case result
          when :paused then "paused until #{paused}"
          when nil || false then :unknown
          else result
          end
        end

        private

        def perform
          @information
        end
      end
    end
  end
end
