# frozen_string_literal: true

module LoopsSdk
  class CustomFields < Base
    class << self
      def list
        make_request(:get, "v1/contacts/customFields")
      end
    end
  end
end
