# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to delete messages
  module DeleteMethods
    # Delete all messages in inbox
    # @return [nil]
    def delete_all_messages
      login
      @imap.select('INBOX')
      @imap.store(@imap.search(['ALL']), '+FLAGS', [:Deleted]) unless @imap.search(['ALL']).empty?
      OnlyofficeLoggerHelper.log('Delete all messages')
      close
    end

    # Delete email by subject
    # @param subject [String] email title
    # @return [nil]
    def delete_email_by_subject(subject)
      login
      @imap.select('INBOX')
      id_emails = @imap.search(['SUBJECT', subject.dup.force_encoding('ascii-8bit')])
      @imap.store(id_emails, '+FLAGS', [:Deleted]) unless id_emails.empty?
      close
    end
  end
end
