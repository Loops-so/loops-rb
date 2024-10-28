# frozen_string_literal: true

module LoopsSdk
  class Contacts < Base
    class << self
      def create(email:, properties: {}, mailing_lists: {})
        contact_data = {
          email: email,
          mailingLists: mailing_lists
        }.merge(properties)
        make_request(:post, "v1/contacts/create", {}, contact_data)
      end

      def update(email:, properties: {}, mailing_lists: {})
        contact_data = {
          email: email,
          mailingLists: mailing_lists
        }.merge(properties)
        make_request(:put, "v1/contacts/update", {}, contact_data)
      end

      def find(email: nil, user_id: nil)
        raise ArgumentError, "Only one parameter is permitted." if email && user_id
        raise ArgumentError, "You must provide an email or user_id value." if email.nil? && user_id.nil?

        params = email ? { email: email } : { userId: user_id }
        make_request(:get, "v1/contacts/find", params)
      end

      def delete(email: nil, user_id: nil)
        raise ArgumentError, "Only one parameter is permitted." if email && user_id
        raise ArgumentError, "You must provide an email or user_id value." if email.nil? && user_id.nil?

        body = email ? { email: email } : { userId: user_id }
        make_request(:post, "v1/contacts/delete", {}, body)
      end
    end
  end
end
