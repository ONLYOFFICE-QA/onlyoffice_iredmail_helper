# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods for working with Mail account Mailboxes
  module MailboxesMethods
    # @return [Array<String>] list of folder names
    def mailboxes
      login
      @imap.select('INBOX')
      folders = @imap.list('%', '%').map(&:name)
      close
      folders
    end

    # Create new mailbox with name
    # @param name [String] name of folder
    # @return [nil]
    def create_mailbox(name)
      login
      @imap.select('INBOX')
      @imap.create(name)
      close
    end

    # Delete mailbox with name
    # @param name [String] name of folder
    # @return [nil]
    def delete_mailbox(name)
      login
      @imap.select('INBOX')
      @imap.delete(name)
      close
    end
  end
end
