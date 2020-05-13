# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper, '#email_by_date_and_title' do
  mail_helper = described_class.new
  let(:title) { "email title: #{Time.now.nsec}" }

  before do
    mail_helper.delete_all_messages
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
  end

  it 'email_by_date_and_message' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    expect(mail_helper.email_by_date_and_title(subject: title,
                                               timeout: 10)[:subject]).to eq(title)
  end

  it 'email_by_date_and_message subject start with match' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    expect(mail_helper.email_by_date_and_title(subject: 'email title',
                                               timeout: 10)[:subject]).to eq(title)
  end

  describe 'move_out messages' do
    it 'move_out message is enable by default' do
      mail_helper.email_by_date_and_title(subject: title,
                                          timeout: 10)
      expect(mail_helper.email_by_date_and_title(subject: title,
                                                 timeout: 10)).to be_falsey
    end

    it 'move_out can be disabled' do
      mail_helper.email_by_date_and_title(subject: title,
                                          timeout: 10,
                                          move_out: false)
      expect(mail_helper.email_by_date_and_title(subject: 'email title',
                                                 timeout: 10)[:subject]).to eq(title)
    end
  end
end
