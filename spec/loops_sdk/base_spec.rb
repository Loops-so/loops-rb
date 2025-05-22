# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Base do
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
    # Make make_request public for testing
    described_class.class_eval { public_class_method :make_request }
  end

  describe ".make_request" do
    let(:path) { "v1/test" }
    let(:method) { :get }
    let(:params) { { foo: "bar" } }
    let(:body) { { baz: "qux" } }
    let(:headers) { { "Custom-Header" => "value" } }
    let(:merged_headers) { default_headers.merge(headers) }

    it "makes a successful GET request" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with(path)
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with(params)
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')

      result = described_class.make_request(method: method, path: path, params: params)
      expect(result).to eq({ "success" => true })
    end

    it "includes body in POST request" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with(path)
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse({ baz: "qux" }.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')

      result = described_class.make_request(method: :post, path: path, body: body)
      expect(result).to eq({ "success" => true })
    end

    it "includes custom headers merged with default headers" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with(path)
        expect(req).to receive(:headers=).with(merged_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')

      result = described_class.make_request(method: method, path: path, headers: headers)
      expect(result).to eq({ "success" => true })
    end

    it "allows custom headers to override default headers" do
      custom_content_type = "application/xml"
      custom_headers = { "Content-Type" => custom_content_type }
      expected_headers = default_headers.merge(custom_headers)

      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with(path)
        expect(req).to receive(:headers=).with(expected_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')

      result = described_class.make_request(method: method, path: path, headers: custom_headers)
      expect(result).to eq({ "success" => true })
    end

    it "raises an error when the API returns an error" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with(path)
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(400)
      allow(response).to receive(:body).and_return('{"error":"Bad Request"}')
      allow(response).to receive(:headers).and_return({})

      expect {
        described_class.make_request(method: method, path: path)
      }.to raise_error(LoopsSdk::APIError, "API request failed with status 400")
    end

    it "raises a rate limit error when the API returns 429" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with(path)
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(429)
      allow(response).to receive(:body).and_return('{"error":"Rate limit exceeded"}')
      allow(response).to receive(:headers).and_return({
        "x-ratelimit-limit" => "100",
        "x-ratelimit-remaining" => "0"
      })

      expect {
        described_class.make_request(method: method, path: path)
      }.to raise_error(LoopsSdk::RateLimitError, "Rate limit of 100 requests per second exceeded.")
    end
  end

  describe "Error classes" do
    describe "RateLimitError" do
      it "initializes with limit and remaining values" do
        error = LoopsSdk::RateLimitError.new("100", "0")
        expect(error.limit).to eq("100")
        expect(error.remaining).to eq("0")
        expect(error.message).to eq("Rate limit of 100 requests per second exceeded.")
      end
    end

    describe "APIError" do
      it "initializes with status and body" do
        error = LoopsSdk::APIError.new(400, '{"message":"Bad Request"}')
        expect(error.statusCode).to eq(400)
        expect(error.json).to eq('{"message":"Bad Request"}')
        expect(error.message).to eq('API request failed with status 400: Bad Request')
      end

      it "handles non-JSON body" do
        error = LoopsSdk::APIError.new(500, "Internal Server Error")
        expect(error.statusCode).to eq(500)
        expect(error.json).to eq("Internal Server Error")
        expect(error.message).to eq("API request failed with status 500")
      end
    end
  end
end 