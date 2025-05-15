# frozen_string_literal: true

module LoopsSdk
  class Contacts < Base
    class << self
      def create(email:, properties: {}, mailing_lists: {})
        contact_data = {
          email: email,
          mailingLists: mailing_lists
        }.merge(properties)
        make_request(method: :post, path: "v1/contacts/create", body: contact_data)
      end

      def update(email:, properties: {}, mailing_lists: {})
        contact_data = {
          email: email,
          mailingLists: mailing_lists
        }.merge(properties)
        make_request(method: :put, path: "v1/contacts/update", body: contact_data)
      end

      def find(email: nil, user_id: nil)
        raise ArgumentError, "Only one parameter is permitted." if email && user_id
        raise ArgumentError, "You must provide an email or user_id value." if email.nil? && user_id.nil?

        params = email ? { email: email } : { userId: user_id }
        make_request(method: :get, path: "v1/contacts/find", params: params)
      end

      def delete(email: nil, user_id: nil)
        raise ArgumentError, "Only one parameter is permitted." if email && user_id
        raise ArgumentError, "You must provide an email or user_id value." if email.nil? && user_id.nil?

        body = email ? { email: email } : { userId: user_id }
        make_request(method: :post, path: "v1/contacts/delete", body: body)
      end
    end
  end
end
