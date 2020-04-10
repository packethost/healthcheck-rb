require 'spec_helper'
require 'healthcheck/application'
require 'healthcheck/checks/sanity'
require 'support/test_check_one'

RSpec.describe Healthcheck::Application do
  before do
    Healthcheck.configure do |config|
      config.checks = [
        Healthcheck::Checks::Sanity,
        'Healthcheck::Checks::TestCheckOne',
        Healthcheck::Checks::TestCheckTwo.new
      ]
    end
  end
  subject { Healthcheck::Application.new }
  let(:response) do
    status, headers, body = subject.call(env)
    Rack::Response.new(body, status, headers)
  end
  let(:parsed_response_body) { JSON.parse(response.body.first) }

  describe '#call' do
    context 'with no query string' do
      let(:env) { {} }

      it 'runs all of the checks' do
        expect(response).to be_ok
        expect(parsed_response_body.size).to be(3)
        expect(parsed_response_body).to have_key('sanity')
        expect(parsed_response_body).to have_key('test_check_one')
        expect(parsed_response_body).to have_key('test_check_two')
      end
    end

    context 'with no checks specified in the query string' do
      let(:env) { { Rack::QUERY_STRING => 'only=' } }

      it 'runs all of the checks' do
        expect(response).to be_ok
        expect(parsed_response_body.size).to be(3)
        expect(parsed_response_body).to have_key('sanity')
        expect(parsed_response_body).to have_key('test_check_one')
        expect(parsed_response_body).to have_key('test_check_two')
      end
    end

    context 'with a single check in the query string' do
      let(:env) { { Rack::QUERY_STRING => 'only=sanity' } }

      it 'only runs the specified checks' do
        expect(response).to be_ok
        expect(parsed_response_body.size).to be(1)
        expect(parsed_response_body).to have_key('sanity')
      end
    end

    context 'with an array of checks in the query string' do
      let(:env) { { Rack::QUERY_STRING => 'only[]=sanity&only[]=test_check_one' } }

      it 'only runs the specified checks' do
        expect(response).to be_ok
        expect(parsed_response_body.size).to be(2)
        expect(parsed_response_body).to have_key('sanity')
        expect(parsed_response_body).to have_key('test_check_one')
      end
    end

    context 'with an except value in the query string' do
      let(:env) { { Rack::QUERY_STRING => 'except=test_check_one' } }

      it 'only runs the specified checks' do
        expect(response).to be_ok
        expect(parsed_response_body.size).to be(2)
        expect(parsed_response_body).to have_key('sanity')
        expect(parsed_response_body).to have_key('test_check_two')
      end
    end
  end
end
