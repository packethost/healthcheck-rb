require 'spec_helper'

describe Healthcheck do
  it 'has a version number' do
    expect(Healthcheck::VERSION).not_to be nil
  end
end
