# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ann_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "ann_wrapper"
  spec.version       = AnnWrapper::VERSION
  spec.authors       = ["shawntoffel"]
  spec.email         = ["getkura+ann_wrapper@gmail.com"]
  spec.description   = 'A simple wrapper for the Anime News Network API'
  spec.summary       = 'Anime News Network API wrapper'
  spec.homepage      = "http://getkura.github.io/ann_wrapper/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9"

  spec.add_runtime_dependency "nokogiri"
	
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "sinatra"
end
