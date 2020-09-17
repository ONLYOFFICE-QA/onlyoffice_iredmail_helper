# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to work with messages
  module MessageMethods
    # Mark message as seen
    # @param message_id [Integer] message to mark
    # @param close_connection [True, False] should connection be closed
    # @return [nil]
    def mark_message_as_seen(message_id, close_connection: true)
      login
      @imap.select('INBOX')
      @imap.store(message_id, '+FLAGS', [:Seen])
      close if close_connection
    end
  end
end
