# frozen_string_literal: true

module LoopsSdk
  class Themes < Base
    class << self
      def list(perPage: 20, cursor: nil)
        make_request(method: :get, path: "v1/themes", params: { perPage: perPage, cursor: cursor })
      end

      def get(theme_id:)
        make_request(method: :get, path: "v1/themes/#{theme_id}")
      end

      def create(name:, styles: nil)
        body = { name: name, styles: styles }.compact
        make_request(method: :post, path: "v1/themes", body: body)
      end

      def update(theme_id:, name: nil, styles: nil)
        body = { name: name, styles: styles }.compact
        make_request(method: :post, path: "v1/themes/#{theme_id}", body: body)
      end
    end
  end
end
