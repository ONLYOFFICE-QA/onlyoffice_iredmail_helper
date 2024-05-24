# Change log

## master (unreleased)

### New Features

* Add `yamllint` check in CI
* Add `ruby-3.2` to CI
* Add `ruby-3.3` to CI
* Add `dependabot` check for `GitHub Actions`
* Add `rake cleanup_mailboxes` to clean mailboxes created by CI

### Fixes

* Fix `markdownlint` failure because of old `nodejs` in CI
* Fix warning on login about deprecated `LOGIN` type of login
* Fix test suite not to create 1 new mailbox for every run

### Changes

* Remove `codeclimate` config, since we don't use it any more
* Check `dependabot` at 8:00 Moscow time daily
* Changes from `rubocop-rspec` update to 2.9.0
* Fix `rubocop-1.28.1` code issues
* Set `--fail-fast` for rspec tests
* Drop support of `ruby-2.6`, `ruby-2.7`, since it's EOL'ed
* Extract creating SMTP connection to separate method
* Migrate to `codecov-4` CI action

## 1.0.0 (2022-01-27)

### New Features

* Add all supported version to CI

### Fixes

* Fix dependencies problem with `net/smpt` on `ruby-3.1`

## 0.3.0 (2021-11-27)

### New Features

* Add `include_read: true` option to all mail getters to include even read mail
* Add `CodeQL` check in CI

### Changes

* Freeze dependencies version in `Gemfile.lock`
* Use new uploader for `codecov` instead of deprecated one
* Require `mfa` for releasing gem
* Reduce rubocop `Metrics/ClassLength` metric
* Increase test coverage

## 0.2.1 (2020-09-17)

### Fixes

* Do not try to login more than once
* Fix missing `markdownlint` config

## 0.2.0 (2020-09-17)

### New Features

* Add `IredMailHelper#get_email_by_subject` method
* Add support of `rubocop-performance`,
  `rubocop-rake` and `rubocop-rspec`
* New method `email_by_date_and_title`
* Add `markdownlint` checks in CI
* Add `dependabot` config
* Add `rubocop` checks in CI
* Add missing `yard` documentation
* Add task checking for 100% documentation
* Add `rake` task for release gem on `rubygems`
  and `GitHub Packages`
* New method to work with mailboxes `IredMailHelper#mailboxes`,
  `IredMailHelper#create_mailbox`, `IredMailHelper#delete_mailbox`
* Create archive folder while `move_out: true`

### Fixes

* Fix using `delete_email_by_subject` for frozen strings
* Fix coverage reports on non-ci environments

### Changes

* Minor refactor in private method
* Use `mail_by_subject` insetead of `get_email_by_subject`
* `email_by_date_and_title` perform `start_with?` match for subject
* Add `range` param to `email_by_date_and_title` to specify day
  range in which to search for emails
* Use `GitHub Actions` instead of `TravisCI`
* Move source to `ONLYOFFICE-QA` organization
* Cleanup `gemspec` file
* Drop support of ruby <= 2.4 since they're EOLed
* Freeze all development dependencies
* Extract `IredMailHelper#mark_message_as_seen` to method
