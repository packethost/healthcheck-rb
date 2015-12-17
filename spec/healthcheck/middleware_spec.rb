require 'spec_helper'
require 'healthcheck/middleware'
require 'healthcheck/checks/sanity'
require 'rack/lint'
require 'rack/mock'

RSpec.describe Healthcheck::Middleware do
  let(:wrapper) do
    Rack::Lint.new Healthcheck::Middleware.new(app)
  end

  let(:app) do
    double(Proc).tap do |mock|
      allow(mock).to receive(:call).and_return([200, {}, []])
    end
  end

  let(:client) { Rack::MockRequest.new(wrapper) }

  before do
    Healthcheck.configure do |config|
      config.checks = [Healthcheck::Checks::Sanity]
    end
  end

  it 'returns a health report' do
    response = client.get('/healthcheck')
    parsed_response_body = JSON.parse(response.body)
    expect(parsed_response_body).to have_key('sanity')
    expect(parsed_response_body['sanity']).to eq('ok')
  end

  it 'ignores non-healthcheck routes' do
    expect(app).to receive(:call).once
    client.get('/some-random-path')
  end
end
