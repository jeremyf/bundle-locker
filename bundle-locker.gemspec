# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundle-locker/version'

Gem::Specification.new do |gem|
  gem.name          = "bundle-locker"
  gem.version       = Bundle::Locker::VERSION
  gem.authors       = ["Jeremy Friesen"]
  gem.email         = ["jeremy.n.friesen@gmail.com"]
  gem.description   = %q{Lock Gemfile gem declarations to specific Gemfile.lock versions}
  gem.summary       = %q{Lock Gemfile gem declarations to specific Gemfile.lock versions}
  gem.homepage      = "https://github.com/jeremyf/bundle-locker"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
