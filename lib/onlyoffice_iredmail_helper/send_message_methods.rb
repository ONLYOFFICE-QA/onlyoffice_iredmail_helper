# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to send message
  module SendMessageMethods
    # Form a email string
    # @param msg_data [Hash] params
    # @return [String] formed mail message
    def create_msg(msg_data = {})
      <<~END_OF_MESSAGE
        From: #{@username}
        To: #{msg_data[:mailto]}
        Subject: #{msg_data[:subject]}
        Date: #{Time.now.rfc2822}
        Message-Id: "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{@username.split('@').last}"
        
        #{msg_data[:body]}
      END_OF_MESSAGE
    end

    # Send mail
    # @param options [Hash] hash with params
    # @return [nil]
    def send_mail(options = {})
      options[:subject] ||= @default_subject
      options[:body] ||= @default_body
      options[:mailto] ||= @default_user
      smtp = Net::SMTP.start(@domainname, 25, @username, @username, @password, :login)
      smtp.send_message create_msg(options), @username, options[:mailto]
      smtp.finish
    end
  end
end
