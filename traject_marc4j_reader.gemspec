# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traject/marc4j_reader/version'

Gem::Specification.new do |spec|
  spec.name          = "traject_marc4j_reader"
  spec.version       = Traject::Marc4jReader::VERSION
  spec.authors       = ["Bill Dueber"]
  spec.email         = ["bill@dueber.com"]
  spec.summary       = %q{Use marc4j (java) library under traject}
  spec.description   = %q{Allows you to leverage marc-marc4j to use marc4j as a reader under traject when using jruby }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.platform      = 'java'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "traject"
  spec.add_dependency "marc", ">= 0.8.0"
  spec.add_dependency "marc-marc4j", ">=0.1.1" # use and convert marc4j


  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
