# frozen_string_literal: true

module LoopsSdk
  class ContactProperties < Base
    class << self
      def create(name:, type:)
        body = {
          name: name,
          type: type
        }
        make_request(:post, "v1/contacts/properties", {}, body)
      end
      def list(list: nil)
        raise ArgumentError, "List value must be nil, 'custom' or 'all'." unless [nil, "custom", "all"].include?(list)
        make_request(:get, "v1/contacts/properties", {list: list || "all"})
      end
    end
  end
end
