# Change log

## master (unreleased)

## 0.2.1 (2020-09-17)

### Fixes

* Do not try to login more than once

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
