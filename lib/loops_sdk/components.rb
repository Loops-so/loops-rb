# frozen_string_literal: true

module LoopsSdk
  class Components < Base
    class << self
      def list(perPage: 20, cursor: nil)
        make_request(method: :get, path: "v1/components", params: { perPage: perPage, cursor: cursor })
      end

      def get(component_id:)
        make_request(method: :get, path: "v1/components/#{component_id}")
      end

      def create(name:, lmx:)
        make_request(method: :post, path: "v1/components", body: { name: name, lmx: lmx })
      end

      def update(component_id:, name: nil, lmx: nil)
        body = { name: name, lmx: lmx }.compact
        make_request(method: :post, path: "v1/components/#{component_id}", body: body)
      end
    end
  end
end
