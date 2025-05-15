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
  end

  describe ".make_request" do
    let(:params) { { key: "value" } }
    let(:body) { { data: "test" } }

    context "with successful response" do
      it "makes a successful request and parses JSON response" do
        expect(connection).to receive(:send).with(
          method: :get,
          path: "/test",
          headers: default_headers,
          params: params,
          body: nil
        ) do |**_kwargs, &block|
          req = double("req")
          block.call(req)
          response
        end
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('{"data":"test"}')
        result = described_class.send(:make_request, method: :get, path: "/test", params: params)
        expect(result).to eq({ "data" => "test" })
      end

      it "includes body in request when provided" do
        expect(connection).to receive(:send).with(
          method: :post,
          path: "/test",
          headers: default_headers,
          params: {},
          body: body
        ) do |**_kwargs, &block|
          req = double("req")
          expect(req).to receive(:body=) do |request_body|
            expect(JSON.parse(request_body)).to eq(JSON.parse(body.to_json))
          end
          block.call(req)
          response
        end
        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('{"success":true}')
        result = described_class.send(:make_request, method: :post, path: "/test", body: body)
        expect(result).to eq({ "success" => true })
      end
    end

    context "with rate limit error" do
      it "raises RateLimitError" do
        expect(connection).to receive(:send).with(
          method: :get,
          path: "/test",
          headers: default_headers,
          params: params,
          body: nil
        ) do |**_kwargs, &block|
          req = double("req")
          block.call(req)
          response
        end
        allow(response).to receive(:status).and_return(429)
        allow(response).to receive(:headers).and_return(
          "x-ratelimit-limit" => "100",
          "x-ratelimit-remaining" => "0"
        )
        expect {
          described_class.send(:make_request, method: :get, path: "/test", params: params)
        }.to raise_error(LoopsSdk::RateLimitError) do |error|
          expect(error.limit).to eq("100")
          expect(error.remaining).to eq("0")
        end
      end
    end

    context "with API error" do
      it "raises APIError with status and message" do
        expect(connection).to receive(:send).with(
          method: :get,
          path: "/test",
          headers: default_headers,
          params: params,
          body: nil
        ) do |**_kwargs, &block|
          req = double("req")
          block.call(req)
          response
        end
        allow(response).to receive(:status).and_return(400)
        allow(response).to receive(:body).and_return('{"message":"Bad Request"}')
        expect {
          described_class.send(:make_request, method: :get, path: "/test", params: params)
        }.to raise_error(LoopsSdk::APIError) do |error|
          expect(error.statusCode).to eq(400)
          expect(error.json).to eq('{"message":"Bad Request"}')
        end
      end
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