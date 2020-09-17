# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Modules to get mail by different parameters
  module MailGetters
    # Search email by specific date and message title
    # @param date [Date] date to search
    # @param subject [String] check if message is start_with this string
    # @param timeout [Integer] How much time to wait in seconds
    # @param range [Integer] range in days to extend specified date
    # @return [Hash, False] mail data and false is none found
    def email_by_date_and_title(date: Date.today,
                                subject: nil,
                                timeout: 300,
                                move_out: true,
                                range: 1)
      start_date = (date - range).strftime('%d-%b-%Y')
      end_date = (date + range).strftime('%d-%b-%Y')

      login
      @imap.select('INBOX')
      start_time = Time.now
      while (Time.now - start_time) < timeout
        @imap.search(['SINCE', start_date, 'BEFORE', end_date]).each do |message_id|
          mail_data = get_mail_data(message_id)
          next unless mail_data[:subject].start_with?(subject)

          if move_out
            move_out_message(message_id)
          else
            @imap.store(message_id, '+FLAGS', [:Seen])
            close
          end
          return mail_data
        end
      end
      false
    end

    # Get email text body by subject
    # @param options [Hash] options of get
    # @param times [Integer] count to check
    # @return [String] text body
    def get_text_body_email_by_subject(options = {}, times = 300)
      mail = mail_by_subject(options, times)
      return nil unless mail

      mail[:body]
    end

    # Get email html body by subject
    # @param options [Hash] options of get
    # @param times [Integer] count to check
    # @return [String] html body
    def get_html_body_email_by_subject(options = {}, times = 300)
      mail = mail_by_subject(options, times)
      return nil unless mail

      mail[:html_body]
    end
  end
end
