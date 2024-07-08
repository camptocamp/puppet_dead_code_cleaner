source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

group :release do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.16.4', require: false
end

group :coverage, optional: ENV['COVERAGE'] != 'yes' do
  gem 'codecov', require: false
  gem 'simplecov-console', require: false
end

group :development do
  gem 'rake', '~> 13.0', '>= 13.0.6'
  gem 'rspec', '~> 3.12'
  gem 'rspec-collection_matchers', '~> 1.2'
  gem 'rspec-its', '~> 1.3'
  gem 'voxpupuli-rubocop', '~> 2.0'
end
