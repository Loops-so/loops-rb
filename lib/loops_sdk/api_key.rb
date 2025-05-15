# frozen_string_literal: true

module LoopsSdk
  class ApiKey < Base
    class << self
      def test
        make_request(method: :get, path: "v1/api-key")
      end
    end
  end
end
