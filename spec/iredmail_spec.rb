require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper do
  mail_helper = OnlyofficeIredmailHelper::IredMailHelper.new
  let(:subject) { "email title: #{Time.now.nsec}" }

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
