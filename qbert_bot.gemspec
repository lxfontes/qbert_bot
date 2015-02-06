# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qbert_bot/version'

Gem::Specification.new do |spec|
  spec.name          = "qbert_bot"
  spec.version       = QbertBot::VERSION
  spec.authors       = ["lxfontes"]
  spec.email         = ["lxfontes@gmail.com"]
  spec.summary       = %q{The no frills ruby bot for Slack}
  spec.description   = %q{}
  spec.homepage      = "http://github.com/lxfontes/qbert_bot"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{bin,lib}/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rufus-scheduler', '~> 3.0'
  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'faraday', '~> 0.9'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
