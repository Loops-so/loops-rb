# frozen_string_literal: true

module LoopsSdk
  class Base
    class << self
      private

      def handle_response(response)
        case response.status
        when 200
          JSON.parse(response.body)
        when 400, 404, 405, 409, 500
          raise APIError.new(response.status, response.body)
        else
          raise APIError.new(response.status, "Unexpected error occurred")
        end
      end

      def make_request(method, path, params = {}, body = nil)
        response = LoopsSdk.configuration.connection.send(method, path, params) do |req|
          req.body = body.to_json if body
        end
        handle_response(response)
      end
    end
  end

  # The `APIError` class in Ruby represents an error that occurs during an API request with specific
  # status and response body information.
  class APIError < StandardError
    attr_reader :status, :body

    def initialize(status, body)
      @status = status
      @body = body
      super("API request failed with status #{status}: #{body}")
    end
  end
end
