# frozen_string_literal: true

require 'rspec'

describe IredMailHelper do
  mail_helper = described_class.new
  let(:subject) { StringHelper.generate_random_number('email title') }

  before { mail_helper.delete_all_messages }

  it 'send_mail' do
    mail_helper.send_mail(subject: subject, mailto: mail_helper.username)
    expect(mail_helper.check_email_by_subject(subject: subject)).to be true
  end

  it 'delete_email_by_subject' do
    mail_helper.send_mail(subject: subject, mailto: mail_helper.username)
    mail_helper.delete_email_by_subject(subject)
    expect(mail_helper.check_email_by_subject({ subject: subject }, 10)).to be false
  end
end
