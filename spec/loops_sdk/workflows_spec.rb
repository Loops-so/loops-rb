# frozen_string_literal: true

require "spec_helper"

RSpec.describe LoopsSdk::Workflows do
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
    it "makes a POST request to create a workflow" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with({ name: "Welcome series" }.to_json)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"cls9t2u4v0210rx20jpuary23"}')

      result = described_class.create(name: "Welcome series")
      expect(result).to eq({ "id" => "cls9t2u4v0210rx20jpuary23" })
    end
  end

  describe ".update" do
    it "makes a POST request to update workflow properties" do
      expected_body = {
        expectedRevisionId: "rev_123",
        name: "Updated name"
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"cls9t2u4v0210rx20jpuary23"}')

      result = described_class.update(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: "rev_123",
        name: "Updated name"
      )
      expect(result).to eq({ "id" => "cls9t2u4v0210rx20jpuary23" })
    end

    it "includes a null expectedRevisionId when provided" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq({ "expectedRevisionId" => nil, "name" => "Updated name" })
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"cls9t2u4v0210rx20jpuary23"}')

      described_class.update(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: nil,
        name: "Updated name"
      )
    end
  end

  describe ".change_mailing_list" do
    it "makes a POST request to change the mailing list" do
      expected_body = {
        expectedRevisionId: "rev_123",
        mailingListId: "cm06f5v0e45nf0ml5754o9cix",
        dryRun: true
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/mailing-list")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"status":"dryRun"}')

      result = described_class.change_mailing_list(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: "rev_123",
        mailing_list_id: "cm06f5v0e45nf0ml5754o9cix",
        dry_run: true
      )
      expect(result).to eq({ "status" => "dryRun" })
    end
  end

  describe ".get_node" do
    it "makes a GET request to fetch a workflow node" do
      expect(connection).to receive(:send).with(:get) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes/clt0u3v5w0232sy31kqvbzs34")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with(nil)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"clt0u3v5w0232sy31kqvbzs34"}')

      result = described_class.get_node(workflow_id: "cls9t2u4v0210rx20jpuary23", node_id: "clt0u3v5w0232sy31kqvbzs34")
      expect(result).to eq({ "id" => "clt0u3v5w0232sy31kqvbzs34" })
    end
  end

  describe ".create_node" do
    it "makes a POST request to insert a node between two nodes" do
      expected_body = {
        expectedRevisionId: "rev_123",
        insertMode: "between",
        nodeTypeName: "TimerAction",
        fromNodeId: "node_a",
        toNodeId: "node_b"
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"node":{"id":"node_c"}}')

      result = described_class.create_node(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: "rev_123",
        insert_mode: "between",
        node_type_name: "TimerAction",
        from_node_id: "node_a",
        to_node_id: "node_b"
      )
      expect(result).to eq({ "node" => { "id" => "node_c" } })
    end
  end

  describe ".update_node" do
    it "makes a POST request to update a workflow node" do
      expected_body = {
        expectedRevisionId: "rev_123",
        payload: { amount: 2, unit: "d" }
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes/clt0u3v5w0232sy31kqvbzs34")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"clt0u3v5w0232sy31kqvbzs34"}')

      result = described_class.update_node(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        node_id: "clt0u3v5w0232sy31kqvbzs34",
        expected_revision_id: "rev_123",
        payload: { amount: 2, unit: "d" }
      )
      expect(result).to eq({ "id" => "clt0u3v5w0232sy31kqvbzs34" })
    end
  end

  describe ".delete_node" do
    it "makes a DELETE request to delete a workflow node" do
      expected_body = {
        expectedRevisionId: "rev_123",
        dryRun: true
      }

      expect(connection).to receive(:send).with(:delete) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes/clt0u3v5w0232sy31kqvbzs34")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"status":"dryRun"}')

      result = described_class.delete_node(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        node_id: "clt0u3v5w0232sy31kqvbzs34",
        expected_revision_id: "rev_123",
        dry_run: true
      )
      expect(result).to eq({ "status" => "dryRun" })
    end
  end

  describe ".add_branch" do
    it "makes a POST request to add a branch" do
      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes/clt0u3v5w0232sy31kqvbzs34/add-branch")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=).with({ expectedRevisionId: "rev_123" }.to_json)
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"node":{"id":"branch_child"}}')

      result = described_class.add_branch(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        node_id: "clt0u3v5w0232sy31kqvbzs34",
        expected_revision_id: "rev_123"
      )
      expect(result).to eq({ "node" => { "id" => "branch_child" } })
    end
  end

  describe ".delete_node_recursive" do
    it "makes a DELETE request to recursively delete nodes" do
      expected_body = {
        expectedRevisionId: "rev_123",
        queuedContactPolicy: "discard"
      }

      expect(connection).to receive(:send).with(:delete) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes/clt0u3v5w0232sy31kqvbzs34/recursive")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"status":"deleted"}')

      result = described_class.delete_node_recursive(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        node_id: "clt0u3v5w0232sy31kqvbzs34",
        expected_revision_id: "rev_123",
        queued_contact_policy: "discard"
      )
      expect(result).to eq({ "status" => "deleted" })
    end
  end
end
