# frozen_string_literal: true
Gem::Specification.new do |spec|
  spec.name = 'lexicon-cli'
  spec.version = '0.2.0'
  spec.authors = ['Ekylibre developers']
  spec.email = ['dev@ekylibre.com']

  spec.summary = 'Basic Cli for the Lexicon'
  spec.required_ruby_version = '>= 2.6.0'
  spec.homepage = 'https://www.ekylibre.com'
  spec.license = 'AGPL-3.0-only'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob(%w[lib/**/*.rb bin/**/* *.gemspec Gemfile Rakefile *.md])

  spec.bindir = 'bin'
  spec.executables << 'lexicon'

  spec.require_paths = ['lib']

  spec.add_dependency 'corindon', '~> 0.8.0'
  spec.add_dependency 'dotenv', '~> 2.7'
  spec.add_dependency 'lexicon-common', '~> 0.2.0'
  spec.add_dependency 'thor', '~> 1.0'
  spec.add_dependency 'zeitwerk', '~> 2.4'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.3.1'
end
