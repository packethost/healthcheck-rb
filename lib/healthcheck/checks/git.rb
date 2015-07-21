require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    class Git < AbstractCheck
      def report
        ENV['GIT_SHA'] || :unknown
      end
    end
  end
end
