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
      OnlyofficeLoggerHelper.log("Get list of mailboxes: #{folders}")
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
      OnlyofficeLoggerHelper.log("Created new mailbox: #{name}")
    end

    # Delete mailbox with name
    # @param name [String] name of folder
    # @return [nil]
    def delete_mailbox(name)
      raise("There is no mailbox #{name} to delete") unless mailboxes.include?(name)

      login
      @imap.select('INBOX')
      @imap.delete(name)
      close
      OnlyofficeLoggerHelper.log("Delete mailbox by name: #{name}")
    end
  end
end
