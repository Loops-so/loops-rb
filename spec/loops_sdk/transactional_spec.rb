# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Transactional do
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response) }
  let(:default_headers) do
    {
      "Authorization" => "Bearer test-key",
      "Content-Type" => "application/json"
    }
  end

  before do
    allow(LoopsSdk.configuration).to receive(:connection).and_return(connection)
    allow(connection).to receive(:headers).and_return(default_headers)
  end

  describe ".list" do
    it "makes a GET request to list transactional emails with default params" do
      expect(connection).to receive(:send).with(
        method: :get,
        path: "v1/transactional",
        headers: default_headers,
        params: { perPage: 20, cursor: nil },
        body: nil
      ) do |**_kwargs, &block|
        req = double("req")
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"data":[]}')
      result = described_class.list
      expect(result).to eq({ "data" => [] })
    end

    it "makes a GET request with custom params" do
      expect(connection).to receive(:send).with(
        method: :get,
        path: "v1/transactional",
        headers: default_headers,
        params: { perPage: 5, cursor: "abc" },
        body: nil
      ) do |**_kwargs, &block|
        req = double("req")
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"data":[{"id":1}]}')
      result = described_class.list(perPage: 5, cursor: "abc")
      expect(result).to eq({ "data" => [{ "id" => 1 }] })
    end
  end

  describe ".send" do
    let(:transactional_id) { "tid_123" }
    let(:email) { "test@example.com" }
    let(:add_to_audience) { true }
    let(:data_variables) { { name: "Dan" } }
    let(:attachments) { [{ filename: "file.txt", content: "abc", content_type: "text/plain" }] }
    let(:transformed_attachments) { [{ filename: "file.txt", content: "abc", contentType: "text/plain" }] }

    it "makes a POST request to send a transactional email with all params" do
      expected_body = {
        transactionalId: transactional_id,
        email: email,
        addToAudience: add_to_audience,
        dataVariables: data_variables,
        attachments: transformed_attachments
      }
      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/transactional",
        headers: default_headers,
        params: {},
        body: expected_body
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      result = described_class.send(
        transactional_id: transactional_id,
        email: email,
        add_to_audience: add_to_audience,
        data_variables: data_variables,
        attachments: attachments
      )
      expect(result).to eq({ "success" => true })
    end

    it "transforms attachment content_type to contentType" do
      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/transactional",
        headers: default_headers,
        params: {},
        body: hash_including(attachments: transformed_attachments)
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["attachments"]).to eq(JSON.parse(transformed_attachments.to_json))
        end
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      described_class.send(
        transactional_id: transactional_id,
        email: email,
        attachments: attachments
      )
    end

    it "makes a POST request with minimal required params" do
      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/transactional",
        headers: default_headers,
        params: {},
        body: hash_including(transactionalId: transactional_id, email: email)
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["transactionalId"]).to eq(transactional_id)
          expect(parsed_body["email"]).to eq(email)
          expect(parsed_body["addToAudience"]).to eq(false)
          expect(parsed_body["dataVariables"]).to eq({})
          expect(parsed_body["attachments"]).to eq([])
        end
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      described_class.send(transactional_id: transactional_id, email: email)
    end

    it "includes custom headers merged with default headers" do
      idempotency_key = "test-key-123"
      custom_headers = { "Idempotency-Key" => idempotency_key }
      expected_headers = default_headers.merge(custom_headers)
      
      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/transactional",
        headers: expected_headers,
        params: {},
        body: hash_including(transactionalId: transactional_id, email: email)
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["transactionalId"]).to eq(transactional_id)
          expect(parsed_body["email"]).to eq(email)
        end
        block.call(req)
        response
      end
      
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      
      described_class.send(
        transactional_id: transactional_id,
        email: email,
        headers: custom_headers
      )
    end

    it "allows custom headers to override default headers" do
      custom_content_type = "application/xml"
      custom_headers = { "Content-Type" => custom_content_type }
      expected_headers = default_headers.merge(custom_headers)
      
      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/transactional",
        headers: expected_headers,
        params: {},
        body: hash_including(transactionalId: transactional_id, email: email)
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["transactionalId"]).to eq(transactional_id)
          expect(parsed_body["email"]).to eq(email)
        end
        block.call(req)
        response
      end
      
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      
      described_class.send(
        transactional_id: transactional_id,
        email: email,
        headers: custom_headers
      )
    end
  end
end 