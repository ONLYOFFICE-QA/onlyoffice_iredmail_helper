# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper, '#email_by_date_and_title' do
  mail_helper = described_class.new
  let(:title) { "email title: #{Time.now.nsec}" }

  before { mail_helper.delete_all_messages }

  it 'email_by_date_and_message' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    expect(mail_helper.email_by_date_and_title(Date.today, title, 10)[:subject]).to eq(title)
  end

  it 'email_by_date_and_message subject start with match' do
    mail_helper.send_mail(subject: title, mailto: mail_helper.username)
    expect(mail_helper.email_by_date_and_title(Date.today, 'email title', 10)[:subject]).to eq(title)
  end
end
