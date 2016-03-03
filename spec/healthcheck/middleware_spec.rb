require 'spec_helper'
require 'healthcheck/middleware'
require 'healthcheck/application'
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
    allow(Healthcheck::Application).to receive(:new).and_call_original
  end

  it 'returns a health report' do
    response = client.get('/healthcheck')
    parsed_response_body = JSON.parse(response.body)
    expect(parsed_response_body).to have_key('sanity')
    expect(parsed_response_body['sanity']).to eq('ok')
  end

  it 'matches any path under the configured healthcheck path' do
    response = client.get('/healthcheck/lalala')
    expect(Healthcheck::Application).to have_received(:new).once
    expect(app).not_to have_received(:call)
    expect(response).to be_ok
  end

  it 'matches paths with query strings' do
    response = client.get('/healthcheck?checks=sanity')
    expect(Healthcheck::Application).to have_received(:new).once
    expect(app).not_to have_received(:call)
    expect(response).to be_ok
  end

  it 'ignores non-healthcheck routes' do
    client.get('/some-random-path')
    expect(app).to have_received(:call).once
    expect(Healthcheck::Application).not_to have_received(:new)
  end
end
