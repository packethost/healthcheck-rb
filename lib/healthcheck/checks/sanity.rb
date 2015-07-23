require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    class Sanity < AbstractCheck
      private

      def perform
        true
      end
    end
  end
end
