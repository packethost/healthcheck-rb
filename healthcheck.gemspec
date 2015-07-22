# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'healthcheck/version'

Gem::Specification.new do |spec|
  spec.name          = 'healthcheck'
  spec.version       = Healthcheck::VERSION
  spec.authors       = ['Jake Bell']
  spec.email         = %w(jake@theunraveler.com)

  spec.summary       = %q{Health check endpoints for Packet ruby apps}
  spec.description   = %q{Health check endpoints for Packet ruby apps}
  spec.homepage      = 'https://github.com/packethost/healthcheck-rb'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = %w(lib)

  spec.add_dependency 'activesupport', '~> 4.2.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'
end
