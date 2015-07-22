require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    module HTTP
      class Faraday < AbstractCheck
        def initialize(connection, path = '/', method = :get)
          @connection = connection
          @path = path
          @method = method
        end

        private

        def perform
          response = @connection.send(@method, @path)

          fail response.body unless response.success?
          true
        rescue => ex
          logger.error "[health report] Error connecting to #{self.class.slug} at #{@method.to_s.upcase} #{@connection.url_prefix}#{@path}: #{ex.message}"
          false
        end
      end
    end
  end
end
