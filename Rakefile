require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

begin
  require 'rubygems'
  require 'github_changelog_generator/task'
rescue LoadError
  # github-changelog-generator is an optional group
else
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix skip-changelog modulesync]
    config.user = 'voxpupuli'
    config.project = 'puppet-ghostbuster'
    config.future_release = Gem::Specification.load("#{config.project}.gemspec").version
  end
end

begin
  require 'rubocop/rake_task'
rescue LoadError
  # RuboCop is an optional group
else
  RuboCop::RakeTask.new(:rubocop) do |task|
    # These make the rubocop experience maybe slightly less terrible
    task.options = ['--display-cop-names', '--display-style-guide', '--extra-details']

    # Use Rubocop's Github Actions formatter if possible
    task.formatters << 'github' if ENV['GITHUB_ACTIONS'] == 'true'
  end
end
