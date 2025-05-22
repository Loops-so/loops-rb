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
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({ cursor: nil, perPage: 20 })
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"data":[]}')

      result = described_class.list
      expect(result).to eq({ "data" => [] })
    end

    it "makes a GET request with custom params" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({ cursor: "abc", perPage: 5 })
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"data":[]}')

      result = described_class.list(perPage: 5, cursor: "abc")
      expect(result).to eq({ "data" => [] })
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

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
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
      expected_body = {
        transactionalId: transactional_id,
        email: email,
        addToAudience: add_to_audience,
        dataVariables: data_variables,
        attachments: transformed_attachments
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
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

    it "makes a POST request with minimal required params" do
      expected_body = {
        transactionalId: transactional_id,
        email: email,
        addToAudience: false,
        dataVariables: {},
        attachments: []
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
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
        email: email
      )
      expect(result).to eq({ "success" => true })
    end

    it "includes custom headers merged with default headers" do
      idempotency_key = "test-key-123"
      custom_headers = { "Idempotency-Key" => idempotency_key }
      expected_headers = default_headers.merge(custom_headers)
      expected_body = {
        transactionalId: transactional_id,
        email: email,
        addToAudience: false,
        dataVariables: {},
        attachments: []
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(expected_headers)
        expect(req).to receive(:params=).with({})
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
        headers: custom_headers
      )
      expect(result).to eq({ "success" => true })
    end

    it "allows custom headers to override default headers" do
      custom_content_type = "application/xml"
      custom_headers = { "Content-Type" => custom_content_type }
      expected_headers = default_headers.merge(custom_headers)
      expected_body = {
        transactionalId: transactional_id,
        email: email,
        addToAudience: false,
        dataVariables: {},
        attachments: []
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/transactional")
        expect(req).to receive(:headers=).with(expected_headers)
        expect(req).to receive(:params=).with({})
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
        headers: custom_headers
      )
      expect(result).to eq({ "success" => true })
    end
  end
end 