require 'spec_helper'

RSpec.describe Healthcheck do
  it 'has a version number' do
    expect(Healthcheck::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'yields a configuration object' do
      expect { |b| Healthcheck.configure(&b) }.to yield_with_args(Healthcheck::Configuration)
    end

    it 'returns the configuration object' do
      expect(Healthcheck.configure {}).to be_a(Healthcheck::Configuration)
    end
  end

  describe '#configuration' do
    it 'returns the current configuration' do
      Healthcheck.configure do |config|
        config.logger = 'test_logger'
      end

      expect(Healthcheck.configuration.logger).to eq('test_logger')
    end
  end

  describe '#reset_configuration!' do
    before do
      Healthcheck.configure do |config|
        config.logger = 'test_logger'
      end
      Healthcheck.reset_configuration!
    end

    it 'clears the current configuration' do
      expect(Healthcheck.configuration.logger).not_to eq('test_logger')
    end
  end
end
