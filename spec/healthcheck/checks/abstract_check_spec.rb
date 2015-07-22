require 'spec_helper'
require 'healthcheck/checks/abstract_check'

class Implementation < Healthcheck::Checks::AbstractCheck
end

RSpec.describe Healthcheck::Checks::AbstractCheck do
  before { Healthcheck.configure { |config| config.logger = 'main_logger' } }
  subject { Implementation.new }

  describe '#logger' do
    context 'when a logger is configured for the instance' do
      before { subject.logger = 'object_logger' }

      it 'returns the instance\'s logger' do
        expect(subject.send(:logger)).to eq('object_logger')
      end
    end

    context 'when no logger is specified' do
      it 'returns the logger from Healthcheck' do
        expect(subject.send(:logger)).to eq('main_logger')
      end
    end
  end

  describe '#perform' do
    it { expect { subject.send(:perform) }.to raise_error(NotImplementedError) }
  end
end
