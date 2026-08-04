# frozen_string_literal: true

module LoopsSdk
  class AudienceSegments < Base
    class << self
      def list(perPage: 20, cursor: nil)
        make_request(method: :get, path: "v1/audience-segments", params: { perPage: perPage, cursor: cursor })
      end

      def get(audience_segment_id:)
        make_request(method: :get, path: "v1/audience-segments/#{audience_segment_id}")
      end

      def create(name:, filter:, description: nil)
        body = { name: name, filter: filter, description: description }.compact
        make_request(method: :post, path: "v1/audience-segments", body: body)
      end
    end
  end
end
