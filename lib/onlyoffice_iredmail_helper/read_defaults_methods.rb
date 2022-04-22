# frozen_string_literal: true

module OnlyofficeIredmailHelper
  # Methods to read default values
  module ReadDefaultsMethods
    private

    # Get S3 key and S3 private key
    # @return [Array <String>] list of keys
    def read_defaults
      return if read_env_defaults

      yaml = YAML.load_file("#{Dir.home}/.gem-onlyoffice_iredmail_helper/config.yml")
      @default_domain = yaml['domain']
      @default_user = yaml['user']
      @default_password = yaml['password'].to_s
      @default_subject = yaml['subject']
    rescue Errno::ENOENT
      raise Errno::ENOENT, 'No config found. Please create ~/.gem-onlyoffice_iredmail_helper/config.yml'
    end

    # Read keys from env variables
    def read_env_defaults
      return false unless ENV.key?['IREDMAIL_PASSWORD']

      @default_domain = ENV.fetch('IREDMAIL_DOMAIN', 'unknown_domain')
      @default_user = ENV.fetch('IREDMAIL_USER', 'unknown_user')
      @default_password = ENV['IREDMAIL_PASSWORD'].to_s
      @default_subject = ENV.fetch('IREDMAIL_SUBJECT', 'unknwon_subject')
    end
  end
end
