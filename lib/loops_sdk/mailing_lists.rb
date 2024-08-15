# frozen_string_literal: true

module LoopsSdk
  class MailingLists < Base
    class << self
      def list
        make_request(:get, "v1/lists")
      end
    end
  end
end
