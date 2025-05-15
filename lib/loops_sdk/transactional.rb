# frozen_string_literal: true

module LoopsSdk
  class Transactional < Base
    class << self
      def list(perPage: 20, cursor: nil)
        make_request(:get, "v1/transactional", params: { perPage: perPage, cursor: cursor })
      end
      def send(transactional_id:, email:, add_to_audience: false, data_variables: {}, attachments: [], headers: {})
        attachments = attachments.map do |attachment|
          attachment.transform_keys { |key| key == :content_type ? :contentType : key }
        end
        email_data = {
          transactionalId: transactional_id,
          email: email,
          addToAudience: add_to_audience,
          dataVariables: data_variables,
          attachments: attachments
        }.compact
        make_request(:post, "v1/transactional", headers: headers, body: email_data)
      end
    end
  end
end
