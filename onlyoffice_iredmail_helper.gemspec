# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'onlyoffice_iredmail_helper/version'
Gem::Specification.new do |s|
  s.name = 'onlyoffice_iredmail_helper'
  s.version = OnlyofficeIredmailHelper:: VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov']
  s.summary = 'ONLYOFFICE Helper Gem for iRedMail'
  s.description = 'ONLYOFFICE Helper Gem for iRedMail. Used in QA'
  s.email = ['shockwavenn@gmail.com']
  s.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  s.homepage = 'https://github.com/onlyoffice-testing-robot/onlyoffice_iredmail_helper'
  s.license = 'AGPL-3.0'
  s.add_runtime_dependency('mail', '~> 2')
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
end
