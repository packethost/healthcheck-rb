require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    module Database
      class ActiveRecord < AbstractCheck
        def self.slug
          :database
        end

        private

        def perform
          ::ActiveRecord::Base.connection.present?
        rescue => ex
          logger.error "[health report] Error connecting to database: #{ex.message}"
          false
        end
      end
    end
  end
end
