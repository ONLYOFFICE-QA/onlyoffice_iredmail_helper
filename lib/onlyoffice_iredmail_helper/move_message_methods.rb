# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to move message
  module MoveMessageMethods
    private

    # Move out message to `checked` directory
    # @param message_id [String] id of message
    # @return [Void]
    def move_out_message(message_id)
      create_mailbox(@mailbox_for_archive) unless mailboxes.include?(@mailbox_for_archive)

      login
      @imap.select('INBOX')
      @imap.copy(message_id, @mailbox_for_archive)
      @imap.store(message_id, '+FLAGS', [:Deleted])
      @imap.expunge
      close
    end

    # Should message be moved out or marked as seen
    # @param [String] message_id message to handle
    # @param [Boolean] move_out should it be moved
    # @return [Void]
    def move_out_or_mark_seen(message_id, move_out)
      if move_out
        move_out_message(message_id)
      else
        mark_message_as_seen(message_id)
      end
    end
  end
end
