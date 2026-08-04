# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Components do
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

  describe ".create" do
    it "makes a POST request to create a component" do
      expected_body = { name: "Header", lmx: "<Paragraph>Welcome</Paragraph>" }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/components")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(201)
      allow(response).to receive(:body).and_return('{"id":"clp2o4i6u8y0t5r3e1w7q9s1"}')

      result = described_class.create(name: "Header", lmx: "<Paragraph>Welcome</Paragraph>")
      expect(result).to eq({ "id" => "clp2o4i6u8y0t5r3e1w7q9s1" })
    end
  end

  describe ".update" do
    it "makes a POST request to update a component" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/components/clp2o4i6u8y0t5r3e1w7q9s1")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with({ name: "Updated Header" }.to_json)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"clp2o4i6u8y0t5r3e1w7q9s1","affectedEmailCount":3}')

      result = described_class.update(component_id: "clp2o4i6u8y0t5r3e1w7q9s1", name: "Updated Header")
      expect(result).to eq({ "id" => "clp2o4i6u8y0t5r3e1w7q9s1", "affectedEmailCount" => 3 })
    end
  end
end
