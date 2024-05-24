# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper do
  let(:mail_helper) { described_class.new }
  let(:folder_name) { SecureRandom.uuid }

  describe '#mailboxes' do
    it '#mailboxes return not empty list of mailboxes' do
      expect(mail_helper.mailboxes).not_to be_empty
    end

    it '#mailboxes return contains INBOX mailboxe' do
      expect(mail_helper.mailboxes).to include('INBOX')
    end
  end

  describe '#create' do
    it '#create_mailbox method create new mailbox' do
      mail_helper.create_mailbox(folder_name)
      expect(mail_helper.mailboxes).to include(folder_name)
      mail_helper.delete_mailbox(folder_name)
    end
  end

  describe '#delete' do
    it '#delete_mailbox deletes created mailbox' do
      mail_helper.create_mailbox(folder_name)
      mail_helper.delete_mailbox(folder_name)
      expect(mail_helper.mailboxes).not_to include(folder_name)
    end

    it '#delete_mailbox fails with correct info if no mailbof' do
      expect { mail_helper.delete_mailbox('foo') }
        .to raise_error(/There is no/)
    end
  end
end
