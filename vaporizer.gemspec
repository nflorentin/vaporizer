# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vaporizer/version'

Gem::Specification.new do |spec|
  spec.name          = "vaporizer"
  spec.version       = Vaporizer::VERSION
  spec.authors       = ["Nicolas Florentin"]
  spec.email         = ["nf.florentin@gmail.com"]
  spec.summary       = 'A lightweight ruby wrapper to consume Leafly API'
  spec.description   = 'Vaporizer is a lightweight ruby wrapper which enable to consume easily the new Leafly API which needs authentication'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'

  spec.add_runtime_dependency('json')
  spec.add_runtime_dependency('httparty')
end
