require 'spec_helper'
require 'logger'

RSpec.describe Healthcheck::Configuration do
  describe '#logger' do
    context 'when a logger is configured' do
      before do
        Healthcheck.configure { |config| config.logger = 'test_logger' }
      end

      it 'returns the configured logger' do
        expect(Healthcheck.configuration.logger).to eq('test_logger')
      end
    end

    context 'default' do
      it 'defaults to logging to STDOUT' do
        expect(Healthcheck.configuration.logger).to be_a(::Logger)
      end
    end
  end
end
