# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ascent/logger/version'

Gem::Specification.new do |spec|
  spec.name          = "ascent-logger"
  spec.version       = Ascent::Logger::VERSION
  spec.authors       = ["Justin Grimes"]
  spec.email         = ["justin.mgrimes@gmail.com"]

  spec.summary       = %q{Logging for ascent }
  spec.description   = %q{Logging for ascent }
  spec.homepage      = "github.com/indigobio/ascent-logger "

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "activesupport", "~> 4.2.1"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
