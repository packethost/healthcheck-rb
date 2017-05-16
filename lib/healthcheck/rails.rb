require 'healthcheck'
require 'healthcheck/middleware'

module Healthcheck
  class Railtie < Rails::Railtie
    initializer 'healthcheck.configure_rails_initialization' do
      Healthcheck.configuration.logger = Rails.logger

      if defined?(Rack::Head)
        app.middleware.insert_after Rack::Head, Healthcheck::Middleware
      elsif defined?(ActiveRecord::ConnectionAdapters::ConnectionManagement)
        app.middleware.insert_after ActiveRecord::ConnectionAdapters::ConnectionManagement, Healthcheck::Middleware
      elsif defined?(ActionDispatch::Callbacks)
        app.middleware.insert_after ActionDispatch::Callbacks, Healthcheck::Middleware
      elsif defined?(Rails::Rack::Logger)
        app.middleware.insert_after Rails::Rack::Logger, Healthcheck::Middleware
      else
        app.middleware.use Healthcheck::Middleware
      end
    end

    private

    def app
      Rails.application
    end
  end
end
