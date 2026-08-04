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
require_relative "loops_sdk/contact_properties"
require_relative "loops_sdk/api_key"
require_relative "loops_sdk/dedicated_sending_ips"
require_relative "loops_sdk/themes"
require_relative "loops_sdk/components"
require_relative "loops_sdk/campaigns"
require_relative "loops_sdk/campaign_groups"
require_relative "loops_sdk/email_messages"
require_relative "loops_sdk/uploads"
require_relative "loops_sdk/audience_segments"
require_relative "loops_sdk/workflows"
require_relative "loops_sdk/event_patterns"
require_relative "loops_sdk/transactional_groups"

module LoopsSdk
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
