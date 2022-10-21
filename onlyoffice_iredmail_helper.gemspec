# frozen_string_literal: true

require_relative 'lib/onlyoffice_iredmail_helper/name'
require_relative 'lib/onlyoffice_iredmail_helper/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeIredmailHelper::NAME
  s.version = OnlyofficeIredmailHelper::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov']
  s.summary = 'ONLYOFFICE Helper Gem for iRedMail'
  s.description = 'ONLYOFFICE Helper Gem for iRedMail. Used in QA'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.email = ['shockwavenn@gmail.com']
  s.files = Dir['lib/**/*']
  s.add_runtime_dependency('mail', '~> 2')
  s.add_runtime_dependency('net-imap', '~> 0')
  s.add_runtime_dependency('net-smtp', '~> 0')
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.add_development_dependency('overcommit', '~> 0')
  s.add_development_dependency('rake', '~> 13')
  s.add_development_dependency('rspec', '~> 3')
  s.add_development_dependency('rubocop', '~> 1')
  s.add_development_dependency('rubocop-performance', '~> 1')
  s.add_development_dependency('rubocop-rake', '~> 0')
  s.add_development_dependency('rubocop-rspec', '~> 2')
  s.add_development_dependency('simplecov-cobertura', '~> 2')
  s.add_development_dependency('yard', '~> 0', '>= 0.9.20')
  s.license = 'AGPL-3.0'
end
