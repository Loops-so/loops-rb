# frozen_string_literal: true

require "faraday"

module LoopsSdk
  class Configuration
    attr_accessor :api_key

    def connection
      @connection ||= Faraday.new(url: "https://app.loops.so/api/") do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers["Authorization"] = "Bearer #{api_key}"
        faraday.headers["Content-Type"] = "application/json"
      end
    end
  end
end
