# frozen_string_literal: true

module LoopsSdk
  class ContactProperties < Base
    class << self
      def create(name:, type:)
        body = {
          name: name,
          type: type
        }
        make_request(method: :post, path: "v1/contacts/properties", body: body)
      end
      def list(list: nil)
        raise ArgumentError, "List value must be nil, 'custom' or 'all'." unless [nil, "custom", "all"].include?(list)
        make_request(method: :get, path: "v1/contacts/properties", params: { list: list || "all" })
      end
    end
  end
end
