require 'healthcheck'
require 'healthcheck/middleware'

module Healthcheck
  class Railtie < Rails::Railtie
    initializer 'healthcheck.configure_rails_initialization' do
      Healthcheck.configuration.logger = Rails.logger
      app.middleware.insert_before 0, Healthcheck::Middleware
    end

    private

    def app
      Rails.application
    end
  end
end
