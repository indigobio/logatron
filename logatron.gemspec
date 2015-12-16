# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logatron/version'

Gem::Specification.new do |spec|
  spec.name          = 'logatron'
  spec.version       = '0.1.9'
  spec.authors       = ['Justin Grimes']
  spec.email         = ['justin.mgrimes@gmail.com']

  spec.summary       = %q{Logging for ascent }
  spec.description   = %q{Logging for ascent }
  spec.homepage      = 'http://github.com/indigobio/logatron'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.1'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.2.0'
end
