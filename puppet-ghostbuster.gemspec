# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'puppet-ghostbuster/version'

Gem::Specification.new do |s|
  s.name        = 'puppet-ghostbuster'
  s.version     = PuppetGhostbuster::VERSION
  s.authors     = ['Camptocamp', 'Vox Pupuli']
  s.homepage    = 'http://github.com/voxpupuli/puppet-ghostbuster'
  s.summary     = 'Dead code detector for Puppet'
  s.description = 'Try and find dead code in Puppet receipts'
  s.licenses    = 'Apache-2.0'

  s.required_ruby_version = '>= 2.7'

  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_development_dependency 'coveralls', '>= 0.8', '< 0.9'
  s.add_development_dependency 'jgrep', '>= 1.0.0', '< 2.0.0'
  s.add_development_dependency 'rake', '>= 13.0.0', '< 14.0.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  s.add_development_dependency 'rspec-its', '~> 1.0'
  s.add_development_dependency 'voxpupuli-rubocop', '~> 3.0.0'
  s.add_runtime_dependency 'json', '>= 2.0', '< 3.0'
  s.add_runtime_dependency 'puppet', '>= 6.0', '< 9.0'
  s.add_dependency         'puppet-lint', '>= 1.0', '< 5.0'
  s.add_runtime_dependency 'puppetdb-ruby', '~> 1.1', '>= 1.1.1'
end
