require 'date'
require 'mail'
require 'net/imap'
require 'net/smtp'
require 'onlyoffice_logger_helper'
require 'time'
require 'yaml'
require 'onlyoffice_iredmail_helper/version'

module OnlyofficeIredmailHelper
  # Class for working with mail
  class IredMailHelper
    attr_reader :username

    def initialize(options = {})
      read_defaults
      @domainname = options[:domainname] || @default_domain
      @username = options[:username] || @default_user
      @password = options[:password] || @default_password
      @subject = options[:subject] || @default_subject
      @body = options[:body]
    end

    def inspect
      "IredMailHelper domain: #{@domainname}, " \
      "user: #{@username}, " \
      "subject: #{@subject}"
    end

    def login
      @imap = Net::IMAP.new(@domainname)
      @imap.authenticate('LOGIN', @username, @password)
    end

    def create_msg(msg_data = {})
      <<END_OF_MESSAGE
From: #{@username}
To: #{msg_data[:mailto]}
Subject: #{msg_data[:subject]}
Date: #{Time.now.rfc2822}
Message-Id: "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{@username.split('@').last}"

#{msg_data[:body]}
END_OF_MESSAGE
    end

    def send_mail(options = {})
      options[:subject] ||= @default_subject
      options[:body] ||= @default_body
      options[:mailto] ||= @default_user
      smtp = Net::SMTP.start(@domainname, 25, @username, @username, @password, :login)
      smtp.send_message create_msg(options), @username, options[:mailto]
      smtp.finish
    end

    def delete_all_messages
      login
      @imap.select('INBOX')
      @imap.store(@imap.search(['ALL']), '+FLAGS', [:Deleted]) unless @imap.search(['ALL']).empty?
      OnlyofficeLoggerHelper.log('Delete all messages')
      @imap.close
      @imap.logout
      @imap.disconnect
    end

    # You need to add '#encoding: ascii-8bit' to your .rb file
    def delete_email_by_subject(subject)
      login
      @imap.select('INBOX')
      id_emails = @imap.search(['SUBJECT', subject.dup.force_encoding('ascii-8bit')])
      @imap.store(id_emails, '+FLAGS', [:Deleted]) unless id_emails.empty?
      @imap.close
      @imap.logout
      @imap.disconnect
    end

    def get_text_body_email_by_subject(options = {}, times = 300)
      login
      @imap.select('INBOX')
      start_time = Time.now
      while Time.now - start_time < times
        get_emails_search_or_new(options).each do |message_id|
          mail = get_mail_data(message_id)
          mail_subject_found = mail[:subject].to_s.upcase
          mail_subject_to_be_found = options[:subject].to_s.upcase
          next unless mail_subject_found.include? mail_subject_to_be_found

          @imap.store(message_id, '+FLAGS', [:Seen])
          @imap.logout
          @imap.disconnect
          return mail[:body]
        end
      end
      nil
    end

    def get_html_body_email_by_subject(options = {}, times = 300)
      login
      @imap.select('INBOX')
      start_time = Time.now
      while Time.now - start_time < times
        get_emails_search_or_new(options).each do |message_id|
          mail = get_mail_data(message_id)
          mail_subject_found = mail[:subject].to_s.upcase
          mail_subject_to_be_found = options[:subject].to_s.upcase
          next unless mail_subject_found.include? mail_subject_to_be_found

          @imap.store(message_id, '+FLAGS', [:Seen])
          @imap.logout
          @imap.disconnect
          return mail[:html_body]
        end
      end
      nil
    end

    def check_email_by_subject(options = {}, times = 300, move_out = false)
      login
      @imap.select('INBOX')
      start_time = Time.now
      while Time.now - start_time < times
        get_emails_search_or_new(options).each do |message_id|
          string_found = get_mail_data(message_id, options[:search])[:subject].to_s.upcase.gsub(/\s+/, ' ')
          string_to_be_found = options[:subject].to_s.upcase.gsub(/\s+/, ' ')
          next unless string_found.include? string_to_be_found

          if move_out
            @imap.copy(message_id, 'checked')
            @imap.store(message_id, '+FLAGS', [:Deleted])
            @imap.expunge
          else
            @imap.store(message_id, '+FLAGS', [:Seen])
          end
          @imap.logout
          @imap.disconnect
          return true
        end
      end
      false
    end

    def get_email_by_subject(options = {}, times = 300, move_out = false)
      login
      @imap.select('INBOX')
      start_time = Time.now
      while Time.now - start_time < times
        get_emails_search_or_new(options).each do |message_id|
          mail = get_mail_data(message_id)
          string_found = mail[:subject].to_s.upcase.gsub(/\s+/, ' ')
          string_to_be_found = options[:subject].to_s.upcase.gsub(/\s+/, ' ')
          next unless string_found.include? string_to_be_found

          if move_out
            @imap.copy(message_id, 'checked')
            @imap.store(message_id, '+FLAGS', [:Deleted])
            @imap.expunge
          else
            @imap.store(message_id, '+FLAGS', [:Seen])
          end
          @imap.logout
          @imap.disconnect
          return mail
        end
      end
      nil
    end

    private

    def get_emails_search_or_new(options)
      if options[:search]
        @imap.search([(options[:search_type] || 'BODY').to_s.upcase, options[:search]])
      else
        @imap.search(['UNSEEN'])
      end
    end

    def get_mail_data(message_id, search = nil)
      msg = @imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string(msg)
      subject = mail.subject.force_encoding('utf-8')
      body = mail.text_part
      body = body.body.to_s.gsub(/\s+/, ' ').strip.force_encoding('utf-8') if body
      html_body = mail.html_part
      html_body = html_body.body.to_s.gsub(/\s+/, ' ').strip.force_encoding('utf-8') if html_body
      @imap.store(message_id, '-FLAGS', [:Seen]) unless search
      { subject: subject, body: body, html_body: html_body }
    end

    # Get S3 key and S3 private key
    # @return [Array <String>] list of keys
    def read_defaults
      return if read_env_defaults

      yaml = YAML.load_file(Dir.home + '/.gem-onlyoffice_iredmail_helper/config.yml')
      @default_domain = yaml['domain']
      @default_user = yaml['user']
      @default_password = yaml['password'].to_s
      @default_subject = yaml['subject']
    rescue Errno::ENOENT
      raise Errno::ENOENT, 'No config found. Please create ~/.gem-onlyoffice_iredmail_helper/config.yml'
    end

    # Read keys from env variables
    def read_env_defaults
      return false unless ENV['IREDMAIL_PASSWORD']

      @default_domain = ENV['IREDMAIL_DOMAIN']
      @default_user = ENV['IREDMAIL_USER']
      @default_password = ENV['IREDMAIL_PASSWORD'].to_s
      @default_subject = ENV['IREDMAIL_SUBJECT']
    end
  end
end
