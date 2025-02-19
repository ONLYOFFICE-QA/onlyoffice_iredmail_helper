# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeIredmailHelper::IredMailHelper, '#use_ssl' do
  it 'use_ssl is false by default' do
    mail_helper = described_class.new
    expect(mail_helper.use_ssl).to be_falsey
  end

  it 'use_ssl is true if set' do
    mail_helper = described_class.new(use_ssl: true)
    expect(mail_helper.use_ssl).to be_truthy
  end

  it 'use_ssl is false if set' do
    mail_helper = described_class.new(use_ssl: false)
    expect(mail_helper.use_ssl).to be_falsey
  end

  it 'if use_ssl enabled connection is established' do
    mail_helper = described_class.new(use_ssl: true)
    mail_helper.login
    expect(mail_helper.instance_variable_get(:@imap)).not_to be_nil
  end

  it 'if use_ssl disabled connection is established' do
    mail_helper = described_class.new(use_ssl: false)
    mail_helper.login
    expect(mail_helper.instance_variable_get(:@imap)).not_to be_nil
  end
end
