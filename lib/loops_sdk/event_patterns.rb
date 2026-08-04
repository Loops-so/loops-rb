# frozen_string_literal: true

require "cgi"

module LoopsSdk
  class EventPatterns < Base
    class << self
      def list(perPage: 20, cursor: nil)
        make_request(method: :get, path: "v1/event-patterns", params: { perPage: perPage, cursor: cursor })
      end

      def get(event_pattern_id:)
        make_request(method: :get, path: "v1/event-patterns/#{event_pattern_id}")
      end

      def get_by_name(event_name:)
        encoded_name = CGI.escapeURIComponent(event_name)
        make_request(method: :get, path: "v1/event-patterns/by-name/#{encoded_name}")
      end
    end
  end
end
