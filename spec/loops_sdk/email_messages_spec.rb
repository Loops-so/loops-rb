# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::EmailMessages do
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

  describe ".get" do
    it "makes a GET request to fetch an email message" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/email-messages/cly8k3m0n0044jpx2bghepq45")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true,"emailMessageId":"cly8k3m0n0044jpx2bghepq45"}')

      result = described_class.get(email_message_id: "cly8k3m0n0044jpx2bghepq45")
      expect(result).to eq({ "success" => true, "emailMessageId" => "cly8k3m0n0044jpx2bghepq45" })
    end
  end

  describe ".update" do
    it "makes a POST request with camelCase body fields" do
      expected_body = {
        expectedRevisionId: "clm9n4o6p0088lrz4dijslt67",
        subject: "Hello",
        previewText: "Preview",
        fromName: "Loops",
        fromEmail: "hello",
        replyToEmail: "support@loops.so",
        lmx: "<Email />"
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/email-messages/cly8k3m0n0044jpx2bghepq45")
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

      result = described_class.update(
        email_message_id: "cly8k3m0n0044jpx2bghepq45",
        expected_revision_id: "clm9n4o6p0088lrz4dijslt67",
        subject: "Hello",
        preview_text: "Preview",
        from_name: "Loops",
        from_email: "hello",
        reply_to_email: "support@loops.so",
        lmx: "<Email />"
      )
      expect(result).to eq({ "success" => true })
    end

    it "omits nil fields from the request body" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/email-messages/cly8k3m0n0044jpx2bghepq45")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with({ subject: "Hello" }.to_json)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')

      result = described_class.update(email_message_id: "cly8k3m0n0044jpx2bghepq45", subject: "Hello")
      expect(result).to eq({ "success" => true })
    end
  end

  describe ".preview" do
    it "makes a POST request to send a preview" do
      expected_body = {
        emails: ["test@example.com"],
        contactProperties: { firstName: "Alex" }
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/email-messages/cly8k3m0n0044jpx2bghepq45/preview")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"cly8k3m0n0044jpx2bghepq45"}')

      result = described_class.preview(
        email_message_id: "cly8k3m0n0044jpx2bghepq45",
        emails: ["test@example.com"],
        contact_properties: { firstName: "Alex" }
      )
      expect(result).to eq({ "id" => "cly8k3m0n0044jpx2bghepq45" })
    end
  end

  describe ".run_guardian" do
    it "makes a GET request to run Guardian checks" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/email-messages/cly8k3m0n0044jpx2bghepq45/guardian")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"errors":[],"warnings":[]}')

      result = described_class.run_guardian(email_message_id: "cly8k3m0n0044jpx2bghepq45")
      expect(result).to eq({ "errors" => [], "warnings" => [] })
    end
  end
end
