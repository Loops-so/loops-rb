# frozen_string_literal: true

require "faraday"
require "json"
require_relative "loops_sdk/version"
require_relative "loops_sdk/configuration"
require_relative "loops_sdk/base"
require_relative "loops_sdk/contacts"
require_relative "loops_sdk/events"
require_relative "loops_sdk/mailing_lists"
require_relative "loops_sdk/transactional"
require_relative "loops_sdk/custom_fields"
require_relative "loops_sdk/api_key"

module LoopsSdk
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
