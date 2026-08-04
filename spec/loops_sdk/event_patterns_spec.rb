# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::EventPatterns do
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
    it "makes a GET request to list event patterns" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/event-patterns")
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
  end

  describe ".get" do
    it "makes a GET request to fetch an event pattern by ID" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/event-patterns/cle1v2e3n4t5p6a7t8t9e0r1")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"cle1v2e3n4t5p6a7t8t9e0r1","eventName":"signup"}')

      result = described_class.get(event_pattern_id: "cle1v2e3n4t5p6a7t8t9e0r1")
      expect(result).to eq({ "id" => "cle1v2e3n4t5p6a7t8t9e0r1", "eventName" => "signup" })
    end
  end

  describe ".get_by_name" do
    it "makes a GET request with a URL-encoded event name" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/event-patterns/by-name/Payment%20Received")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"eventName":"Payment Received"}')

      result = described_class.get_by_name(event_name: "Payment Received")
      expect(result).to eq({ "eventName" => "Payment Received" })
    end
  end
end
