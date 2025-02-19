# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to login and logout
  module LoginMethods
    # Login to email via IMAP
    # @return [nil]
    def login
      return if @imap

      @imap = if @use_ssl
                Net::IMAP.new(@domainname, port: 993, ssl: true)
              else
                Net::IMAP.new(@domainname)
              end
      @imap.authenticate('PLAIN', @username, @password)
      @current_mailbox = nil
      mailbox_select('INBOX')
    end

    private

    # Correct close of mail account
    # @return [Void]
    def close
      @imap.close
      @imap.logout
      @imap.disconnect
      @imap = nil
    end
  end
end
