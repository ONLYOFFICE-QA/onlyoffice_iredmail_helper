# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Modules to get mail by different parameters
  module MailGetters
    # Search email by specific date and message title
    # @param date [Date] date to search
    # @param subject [String] check if message is start_with this string
    # @param timeout [Integer] How much time to wait in seconds
    # @return [Hash, False] mail data and false is none found
    def email_by_date_and_title(date: Date.today,
                                subject: nil,
                                timeout: 300)
      start_date = date.strftime('%d-%b-%Y')
      end_date = (date + 1).strftime('%d-%b-%Y')

      login
      @imap.select('INBOX')
      start_time = Time.now
      while (Time.now - start_time) < timeout
        @imap.search(['SINCE', start_date, 'BEFORE', end_date]).each do |message_id|
          mail_data = get_mail_data(message_id)
          next unless mail_data[:subject].start_with?(subject)

          close
          return mail_data
        end
      end
      false
    end

    def get_text_body_email_by_subject(options = {}, times = 300)
      mail = mail_by_subject(options, times)
      return nil unless mail

      mail[:body]
    end

    def get_html_body_email_by_subject(options = {}, times = 300)
      mail = mail_by_subject(options, times)
      return nil unless mail

      mail[:html_body]
    end
  end
end
