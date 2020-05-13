# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Modules to get mail by different parameters
  module MailGetters
    # Search email by specific date and message title
    # @param date [Date] date to search
    # @param subject [String] title of message
    # @return [Hash, False] mail data and false is none found
    def email_by_date_and_title(date, subject, times = 300)
      start_date = date.strftime('%d-%b-%Y')
      end_date = (date + 1).strftime('%d-%b-%Y')

      login
      @imap.select('INBOX')
      start_time = Time.now
      while Time.now - start_time < times
        @imap.search(['SINCE', start_date, 'BEFORE', end_date]).each do |message_id|
          mail_data = get_mail_data(message_id)
          next unless mail_data[:subject] == subject

          close
          return mail_data
        end
      end
      false
    end
  end
end
