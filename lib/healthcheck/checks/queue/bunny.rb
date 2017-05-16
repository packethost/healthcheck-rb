require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    module Queue
      class Bunny < AbstractCheck
        def initialize(amqp)
          @amqp = amqp
        end

        def self.slug
          :rabbitmq
        end

        private

        def perform
          conn = ::Bunny.new(@amqp)
          conn.start && conn.close
          true
        rescue StandardError => ex
          logger.error "[health report] Error connecting to RabbitMQ: #{ex.message}"
          false
        end
      end
    end
  end
end
