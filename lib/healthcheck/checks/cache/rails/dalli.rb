require 'healthcheck/checks/abstract_check'

module Healthcheck
  module Checks
    module Cache
      module Rails
        class Dalli < AbstractCheck
          def initialize(key = 'some_random_key')
            @key = key
          end

          def self.slug
            :memcache
          end

          private

          def perform
            ::Rails.cache.dalli.with { |client| client.get(@key) }
            true
          rescue StandardError => ex
            logger.error "[health report] Error connecting to memcache: #{ex.message}"
            false
          end
        end
      end
    end
  end
end
