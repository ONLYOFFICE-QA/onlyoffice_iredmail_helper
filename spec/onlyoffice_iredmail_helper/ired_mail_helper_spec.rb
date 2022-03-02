# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper do
  mail_helper = described_class.new
  let(:title) { "email title: #{Time.now.nsec}" }

  before { mail_helper.delete_all_messages }

  it 'has a version number' do
    expect(OnlyofficeIredmailHelper::VERSION).not_to be_nil
  end

  it 'inspect not show any password' do
    expect(mail_helper.inspect).not_to include('password')
  end

  it 'send_mail' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    expect(mail_helper.check_email_by_subject(subject: title)).to be true
  end

  it 'delete_email_by_subject' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    mail_helper.delete_email_by_subject(title)
    expect(mail_helper.check_email_by_subject({ subject: title }, 10)).to be false
  end

  it 'delete_email_by_subject for frozen string' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    mail_helper.delete_email_by_subject(title.freeze)
    expect(mail_helper.check_email_by_subject({ subject: title }, 10)).to be false
  end

  it 'get_email_by_subject' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    expect(mail_helper.get_email_by_subject({ subject: title }, 10)[:subject]).to eq(title)
  end
end
