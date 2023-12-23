# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods for working with Mail account Mailboxes
  module MailboxesMethods
    # @return [Array<String>] list of folder names
    def mailboxes
      login
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
      @imap.delete(name)
      close
      OnlyofficeLoggerHelper.log("Delete mailbox by name: #{name}")
    end

    # Select mailbox with name
    # @param name [String] name of folder
    # @return [nil]
    def mailbox_select(name)
      login

      return if @current_mailbox == name

      @imap.select(name)
      @current_mailbox = name
      OnlyofficeLoggerHelper.log("Mailbox selected: #{name}")
    end
  end
end
