require 'spec_helper'
require 'json'
require 'healthcheck/checks/abstract_check'

RSpec.describe Healthcheck::Report do
  let(:checks) { [CheckOne, 'CheckTwo', CheckThree.new] }
  subject { Healthcheck::Report.new(checks) }

  describe '#initialize' do
    it 'stores a hash of checks' do
      expect(subject.checks[:check_one]).to be_a(CheckOne)
      expect(subject.checks[:check_two]).to be_a(CheckTwo)
      expect(subject.checks[:check_three]).to be_a(CheckThree)
    end
  end

  describe 'ok?' do
    it 'delegates to each of the checks' do
      %i[one two three].each do |name|
        expect(subject.checks[:"check_#{name}"]).to receive(:ok?).once.and_call_original
      end

      subject.ok?
    end

    it 'returns the result of the checks' do
      expect(subject.ok?).to be(false)
    end
  end

  describe 'to_json' do
    it 'collects a report for each of the checks' do
      %i[one two three].each do |name|
        expect(subject.checks[:"check_#{name}"]).to receive(:report).once.and_call_original
      end

      subject.to_json
    end

    it 'returns a JSON report' do
      report = JSON.parse(subject.to_json)
      expect(report['check_one']).to eq('ok')
      expect(report['check_two']).to eq('ok')
      expect(report['check_three']).to eq('broken')
    end
  end
end

class CheckOne < Healthcheck::Checks::AbstractCheck
  private

  def perform
    true
  end
end

class CheckTwo < Healthcheck::Checks::AbstractCheck
  private

  def perform
    true
  end
end

class CheckThree < Healthcheck::Checks::AbstractCheck
  def report
    'broken'
  end

  private

  def perform
    false
  end
end
