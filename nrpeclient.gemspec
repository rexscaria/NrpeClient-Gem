# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nrpeclient/version'

Gem::Specification.new do |spec|
  spec.name          = "nrpeclient"
  spec.version       = Nrpeclient::VERSION
  spec.authors       = ["Arun Scaria"]
  spec.email         = ["arunscaria91@gmail.com"]

  spec.summary       = %q{Ruby version of check_nrpe command from Nagios core}
  spec.description   = %q{Executed the command passed at the remote machine where NRPE daemon is running.}
  spec.homepage      = "https://github.com/scaria/nrpeclient"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir.glob("lib/**/*")
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '~> 0'
end
