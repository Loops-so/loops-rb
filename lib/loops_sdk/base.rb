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
          raise LoopsAPIError.new(response.status, response.body)
        else
          raise LoopsAPIError.new(response.status, "Unexpected error occurred")
        end
      end

      def make_request(method, path, params = {}, body = nil)
        response = Loops.configuration.connection.send(method, path, params) do |req|
          req.body = body.to_json if body
        end
        handle_response(response)
      end
    end
  end

  class LoopsAPIError < StandardError
    attr_reader :status, :body

    def initialize(status, body)
      @status = status
      @body = body
      super("API request failed with status #{status}: #{body}")
    end
  end
end
