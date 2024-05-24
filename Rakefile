# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'onlyoffice_iredmail_helper'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Release gem '
task :release_github_rubygems do
  Rake::Task['release'].invoke
  sh('gem push --key github ' \
     '--host https://rubygems.pkg.github.com/ONLYOFFICE-QA ' \
     "pkg/#{OnlyofficeIredmailHelper::NAME}-" \
     "#{OnlyofficeIredmailHelper::VERSION}.gem")
end

desc 'Cleanup Mailboxes'
task :cleanup_mailboxes do
  api = OnlyofficeIredmailHelper::IredMailHelper.new
  mailboxes = api.mailboxes
  keep_list = %w[Sent Drafts Junk INBOX]
  mailboxes.each do |mailbox|
    next if keep_list.include?(mailbox)

    api.delete_mailbox(mailbox)
  end
end
