# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Themes do
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
    it "makes a POST request to create a theme" do
      expected_body = { name: "Dark mode", styles: { backgroundColor: "#111827" } }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/themes")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(201)
      allow(response).to receive(:body).and_return('{"id":"clt3u5v7w9x1y3z5a7b9c1d3"}')

      result = described_class.create(name: "Dark mode", styles: { backgroundColor: "#111827" })
      expect(result).to eq({ "id" => "clt3u5v7w9x1y3z5a7b9c1d3" })
    end
  end

  describe ".update" do
    it "makes a POST request to update a theme" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/themes/clt3u5v7w9x1y3z5a7b9c1d3")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with({ name: "Updated" }.to_json)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"clt3u5v7w9x1y3z5a7b9c1d3","affectedEmailCount":2}')

      result = described_class.update(theme_id: "clt3u5v7w9x1y3z5a7b9c1d3", name: "Updated")
      expect(result).to eq({ "id" => "clt3u5v7w9x1y3z5a7b9c1d3", "affectedEmailCount" => 2 })
    end
  end
end
