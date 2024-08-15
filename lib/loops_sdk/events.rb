# frozen_string_literal: true

module LoopsSdk
  class Events < Base
    class << self
      def send(event_name:, email: nil, user_id: nil, contact_properties: {}, event_properties: {}, mailing_lists: {})
        raise ArgumentError, "You must provide an email or user_id value." if email.nil? && user_id.nil?

        event_data = {
          email: email,
          userId: user_id,
          eventName: event_name,
          eventProperties: event_properties.compact,
          mailingLists: mailing_lists.compact
        }.merge(contact_properties.compact).compact
        make_request(:post, "v1/events/send", {}, event_data)
      end
    end
  end
end
