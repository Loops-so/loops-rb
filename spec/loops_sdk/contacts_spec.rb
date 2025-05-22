# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Contacts do
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

  describe ".find" do
    context "when searching by email" do
      let(:email) { "test@example.com" }
      let(:expected_response) do
        [{
          "id" => "contact_123",
          "email" => email,
          "firstName" => "Test",
          "lastName" => "User",
          "source" => "API",
          "subscribed" => true,
          "userGroup" => "",
          "userId" => "user_123"
        }]
      end

      it "makes a GET request to find a contact by email" do
        expect(connection).to receive(:send).with(:get) do |&block|
          req = double("req")
          expect(req).to receive(:url).with("v1/contacts/find")
          expect(req).to receive(:headers=).with(default_headers)
          expect(req).to receive(:params=).with({ email: email })
          expect(req).to receive(:body=).with(nil)
          block.call(req)
          response
        end

        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return(expected_response.to_json)
        allow(response).to receive(:headers).and_return({})

        result = described_class.find(email: email)
        expect(result).to eq(expected_response)
      end

      it "returns an empty array when no contact is found" do
        expect(connection).to receive(:send).with(:get) do |&block|
          req = double("req")
          expect(req).to receive(:url).with("v1/contacts/find")
          expect(req).to receive(:headers=).with(default_headers)
          expect(req).to receive(:params=).with({ email: email })
          expect(req).to receive(:body=).with(nil)
          block.call(req)
          response
        end

        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return('[]')
        allow(response).to receive(:headers).and_return({})

        result = described_class.find(email: email)
        expect(result).to eq([])
      end
    end

    context "when searching by user_id" do
      let(:user_id) { "user_123" }
      let(:expected_response) do
        [{
          "id" => "contact_123",
          "email" => "test@example.com",
          "firstName" => "Test",
          "lastName" => "User",
          "source" => "API",
          "subscribed" => true,
          "userGroup" => "",
          "userId" => user_id
        }]
      end

      it "makes a GET request to find a contact by user_id" do
        expect(connection).to receive(:send).with(:get) do |&block|
          req = double("req")
          expect(req).to receive(:url).with("v1/contacts/find")
          expect(req).to receive(:headers=).with(default_headers)
          expect(req).to receive(:params=).with({ userId: user_id })
          expect(req).to receive(:body=).with(nil)
          block.call(req)
          response
        end

        allow(response).to receive(:status).and_return(200)
        allow(response).to receive(:body).and_return(expected_response.to_json)
        allow(response).to receive(:headers).and_return({})

        result = described_class.find(user_id: user_id)
        expect(result).to eq(expected_response)
      end
    end

    context "when validation fails" do
      it "raises an error when both email and user_id are provided" do
        expect {
          described_class.find(email: "test@example.com", user_id: "user_123")
        }.to raise_error(ArgumentError, "Only one parameter is permitted.")
      end

      it "raises an error when neither email nor user_id is provided" do
        expect {
          described_class.find
        }.to raise_error(ArgumentError, "You must provide an email or user_id value.")
      end
    end

    context "when rate limited" do
      let(:email) { "test@example.com" }

      it "raises a RateLimitError when rate limited" do
        expect(connection).to receive(:send).with(:get) do |&block|
          req = double("req")
          expect(req).to receive(:url).with("v1/contacts/find")
          expect(req).to receive(:headers=).with(default_headers)
          expect(req).to receive(:params=).with({ email: email })
          expect(req).to receive(:body=).with(nil)
          block.call(req)
          response
        end

        allow(response).to receive(:status).and_return(429)
        allow(response).to receive(:body).and_return('{"error":"Rate limit exceeded"}')
        allow(response).to receive(:headers).and_return({
          "x-ratelimit-limit" => "10",
          "x-ratelimit-remaining" => "0"
        })

        expect {
          described_class.find(email: email)
        }.to raise_error(LoopsSdk::RateLimitError, "Rate limit of 10 requests per second exceeded.")
      end
    end
  end
end 