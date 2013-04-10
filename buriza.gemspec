lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buriza/version.rb'

Gem::Specification.new do |gem|
  gem.name        = 'buriza'
  gem.version     = Buriza::VERSION
  gem.date        = '2013-04-10'
  gem.summary     = "Cookbook generator for chef plugin"
  gem.description = gem.summary
  gem.authors     = ["dqminh"]
  gem.email       = "dqminh89@gmail.com"
  gem.files       = `git ls-files`.split($/)
  gem.homepage    = 'http://rubygems.org/gems/hola'

  gem.executables   = %w(buriza)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'minitest'
end
