# frozen_string_literal: true

module LoopsSdk
  class Transactional < Base
    class << self
      def send(transactional_id:, email:, add_to_audience: false, data_variables: {}, attachments: [])
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
        make_request(:post, "v1/transactional", {}, email_data)
      end
    end
  end
end
