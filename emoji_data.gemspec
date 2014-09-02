# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emoji_data/version'

Gem::Specification.new do |spec|
  spec.name          = "emoji_data"
  spec.version       = EmojiData::VERSION
  spec.authors       = ["Matthew Rothenberg"]
  spec.email         = ["mrothenberg@gmail.com"]
  spec.description   = %q{Provides classes and helpers for dealing with emoji character data as unicode.  Wraps a library of all known emoji characters and provides convenience methods.}
  spec.summary       = %q{Provides classes and methods for dealing with emoji character data as unicode.}
  spec.homepage      = "https://github.com/mroth/emoji_data.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler',        '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec',          '~> 2.14.1'
  spec.add_development_dependency 'simplecov',      '~> 0.7.1'
  spec.add_development_dependency 'coveralls',      '~> 0.7.0'
  spec.add_development_dependency 'benchmark-ips',  '~> 2.0.0'
  spec.add_development_dependency 'yard',           '~> 0.8.7.4'

  spec.required_ruby_version = '>= 1.9.2'
end
