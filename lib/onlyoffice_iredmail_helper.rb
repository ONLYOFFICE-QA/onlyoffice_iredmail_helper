# frozen_string_literal: true

require 'date'
require 'mail'
require 'net/imap'
require 'net/smtp'
require 'onlyoffice_logger_helper'
require 'time'
require 'yaml'
require_relative 'onlyoffice_iredmail_helper/delete_methods'
require_relative 'onlyoffice_iredmail_helper/login_methods'
require_relative 'onlyoffice_iredmail_helper/mailboxes_methods'
require_relative 'onlyoffice_iredmail_helper/mail_getters'
require_relative 'onlyoffice_iredmail_helper/message_methods'
require_relative 'onlyoffice_iredmail_helper/read_defaults_methods'
require_relative 'onlyoffice_iredmail_helper/send_message_methods'
require_relative 'onlyoffice_iredmail_helper/version'

# Namespace of Gem
module OnlyofficeIredmailHelper
  # Class for working with mail
  class IredMailHelper
    include DeleteMethods
    include LoginMethods
    include MailboxesMethods
    include MailGetters
    include MessageMethods
    include ReadDefaultsMethods
    include SendMessageMethods
    attr_reader :username

    def initialize(options = {})
      read_defaults
      @domainname = options[:domainname] || @default_domain
      @username = options[:username] || @default_user
      @password = options[:password] || @default_password
      @subject = options[:subject] || @default_subject
      @body = options[:body]
      @mailbox_for_archive = 'checked'
    end

    # @return [String] inspect info
    def inspect
      "IredMailHelper domain: #{@domainname}, " \
        "user: #{@username}, " \
        "subject: #{@subject}"
    end

    # Get email
    # @param options [Hash] options of get
    # @param times [Integer] count to check
    # @return [Hash] mail
    def mail_by_subject(options = {}, times = 300)
      login
      @imap.select('INBOX')
      start_time = Time.now
      while Time.now - start_time < times
        get_emails_search_or_new(options).each do |message_id|
          mail = get_mail_data(message_id)
          mail_subject_found = mail[:subject].to_s.upcase
          mail_subject_to_be_found = options[:subject].to_s.upcase
          next unless mail_subject_found.include? mail_subject_to_be_found

          if options[:move_out]
            move_out_message(message_id)
          else
            mark_message_as_seen(message_id)
          end
          return mail
        end
      end
      nil
    end

    # Check if message exists by params
    # @param options [Hash] options of get
    # @param times [Integer] count to check
    # @return [True, False] result of check
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
            move_out_message(message_id)
          else
            mark_message_as_seen(message_id)
          end
          return true
        end
      end
      false
    end

    # Get email by subject
    # @param options [Hash] options of get
    # @param times [Integer] count to check
    # @param move_out [True, False] should message to move out
    # @return [Hash] mail
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
            move_out_message(message_id)
          else
            mark_message_as_seen(message_id)
          end
          return mail
        end
      end
      nil
    end

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

    # Get email list via search or all unseen
    # @param options [Hash] options to search
    # @option options [String] :search call search by this string
    # @option options [Boolean] :include_read should messages marked as read included
    # @return [Array<Mail>] list of mails
    def get_emails_search_or_new(options)
      if options[:search]
        @imap.search([(options[:search_type] || 'BODY').to_s.upcase, options[:search]])
      elsif options[:include_read]
        @imap.search(['ALL'])
      else
        @imap.search(['UNSEEN'])
      end
    end

    # Get mail data by mail id
    # @param message_id [Integer] id of message
    # @param search [String] param to search
    # @return [Hash] found data
    def get_mail_data(message_id, search = nil)
      msg = @imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
      mail = Mail.read_from_string(msg)
      subject = mail.subject.force_encoding('utf-8')
      body = mail.text_part
      body = body.body.to_s.gsub(/\s+/, ' ').strip.force_encoding('utf-8') if body
      html_body = mail.html_part
      html_body = html_body.body.to_s.gsub(/\s+/, ' ').strip.force_encoding('utf-8') if html_body
      mark_message_as_seen(message_id, close_connection: false) unless search
      { subject: subject, body: body, html_body: html_body }
    end
  end
end
