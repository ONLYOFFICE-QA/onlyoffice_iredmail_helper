# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper, '#mail_by_subject' do
  mail_helper = described_class.new
  let(:title) { "email title: #{Time.now.nsec}" }

  before do
    mail_helper.delete_all_messages
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
  end

  it 'mail_by_subject works' do
    expect(mail_helper.mail_by_subject(subject: title)).to be_a(Hash)
  end

  it 'mail_by_subject do not include read mail by default' do
    mail_helper.mail_by_subject(subject: title)
    expect(mail_helper.mail_by_subject({ subject: title }, 1)).to be_nil
  end

  it 'mail_by_subject param include_read include read mail' do
    mail_helper.mail_by_subject(subject: title)
    expect(mail_helper.mail_by_subject(subject: title, include_read: true)).to be_a(Hash)
  end
end
