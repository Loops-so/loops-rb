# frozen_string_literal: true

module LoopsSdk
  class Base
    class << self
      private

      def handle_response(response)
        case response.status
        when 200
          JSON.parse(response.body)
        when 429
          limit = response.headers["x-ratelimit-limit"]
          remaining = response.headers["x-ratelimit-remaining"]
          raise RateLimitError.new(limit, remaining)
        when 400, 404, 405, 409, 500
          raise APIError.new(response.status, response.body)
        else
          raise APIError.new(response.status, "Unexpected error occurred")
        end
      end

      def make_request(method:, path:, headers: {}, params: {}, body: nil)
        merged_headers = LoopsSdk.configuration.connection.headers.merge(headers)

        response = LoopsSdk.configuration.connection.send(method) do |req|
          req.url path
          req.headers = merged_headers
          req.params = params
          req.body = body ? body.to_json : nil
        end

        handle_response(response)
      end
    end
  end

  class RateLimitError < StandardError
    attr_reader :limit, :remaining

    def initialize(limit, remaining)
      @limit = limit
      @remaining = remaining
      super("Rate limit of #{limit} requests per second exceeded.")
    end
  end

  class APIError < StandardError
    attr_reader :statusCode, :json

    def initialize(status, body)
      @statusCode = status
      @json = body
      message = begin
                  parsed = JSON.parse(body)
                  parsed["message"] ? ": #{parsed["message"]}" : ""
                rescue JSON::ParserError
                  ""
                end
      super("API request failed with status #{statusCode}#{message}")
    end
  end
end
