# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to login and logout
  module LoginMethods
    # Login to email via IMAP
    # @return [nil]
    def login
      return if @imap

      @imap = Net::IMAP.new(@domainname)
      @imap.authenticate('PLAIN', @username, @password)
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
