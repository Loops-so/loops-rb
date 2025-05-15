# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Events do
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

  describe ".send" do
    let(:event_name) { "user_signed_up" }
    let(:email) { "test@example.com" }
    let(:user_id) { "user_123" }
    let(:event_properties) { { name: "Dan", plan: "pro" } }
    let(:contact_properties) { { firstName: "Dan", lastName: "Smith" } }
    let(:mailing_lists) { { list1: true, list2: false } }

    it "makes a POST request to send an event with all params" do
      expected_body = {
        eventName: event_name,
        email: email,
        userId: user_id,
        eventProperties: event_properties,
        mailingLists: mailing_lists
      }.merge(contact_properties)

      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/events/send",
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
        event_name: event_name,
        email: email,
        user_id: user_id,
        event_properties: event_properties,
        contact_properties: contact_properties,
        mailing_lists: mailing_lists
      )
      expect(result).to eq({ "success" => true })
    end

    it "makes a POST request with minimal required params (email)" do
      expected_body = {
        eventName: event_name,
        email: email,
        userId: nil,
        eventProperties: {},
        mailingLists: {}
      }

      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/events/send",
        headers: default_headers,
        params: {},
        body: expected_body
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["eventName"]).to eq(event_name)
          expect(parsed_body["email"]).to eq(email)
          expect(parsed_body["userId"]).to be_nil
          expect(parsed_body["eventProperties"]).to eq({})
          expect(parsed_body["mailingLists"]).to eq({})
        end
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      described_class.send(event_name: event_name, email: email)
    end

    it "makes a POST request with minimal required params (user_id)" do
      expected_body = {
        eventName: event_name,
        email: nil,
        userId: user_id,
        eventProperties: {},
        mailingLists: {}
      }

      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/events/send",
        headers: default_headers,
        params: {},
        body: expected_body
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["eventName"]).to eq(event_name)
          expect(parsed_body["email"]).to be_nil
          expect(parsed_body["userId"]).to eq(user_id)
          expect(parsed_body["eventProperties"]).to eq({})
          expect(parsed_body["mailingLists"]).to eq({})
        end
        block.call(req)
        response
      end
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      described_class.send(event_name: event_name, user_id: user_id)
    end

    it "includes custom headers merged with default headers" do
      idempotency_key = "test-key-123"
      custom_headers = { "Idempotency-Key" => idempotency_key }
      expected_headers = default_headers.merge(custom_headers)
      
      expect(connection).to receive(:send).with(
        method: :post,
        path: "v1/events/send",
        headers: expected_headers,
        params: {},
        body: hash_including(eventName: event_name, email: email)
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["eventName"]).to eq(event_name)
          expect(parsed_body["email"]).to eq(email)
        end
        block.call(req)
        response
      end
      
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      
      described_class.send(
        event_name: event_name,
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
        path: "v1/events/send",
        headers: expected_headers,
        params: {},
        body: hash_including(eventName: event_name, email: email)
      ) do |**_kwargs, &block|
        req = double("req")
        expect(req).to receive(:body=) do |body|
          parsed_body = JSON.parse(body)
          expect(parsed_body["eventName"]).to eq(event_name)
          expect(parsed_body["email"]).to eq(email)
        end
        block.call(req)
        response
      end
      
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"success":true}')
      
      described_class.send(
        event_name: event_name,
        email: email,
        headers: custom_headers
      )
    end

    it "raises ArgumentError when neither email nor user_id is provided" do
      expect {
        described_class.send(event_name: event_name)
      }.to raise_error(ArgumentError, "You must provide an email or user_id value.")
    end
  end
end 