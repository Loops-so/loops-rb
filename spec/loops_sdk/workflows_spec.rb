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

  describe ".delete" do
    it "makes a DELETE request to delete a workflow" do
      expected_body = {
        expectedRevisionId: "rev_123"
      }

      expect(connection).to receive(:send).with(:delete) do |&block|
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

      allow(response).to receive(:status).and_return(204)
      allow(response).to receive(:body).and_return("")

      result = described_class.delete(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: "rev_123"
      )
      expect(result).to be_nil
    end

    it "includes confirmDelete when confirming a sending or queued workflow" do
      expected_body = {
        expectedRevisionId: "rev_123",
        confirmDelete: true
      }

      expect(connection).to receive(:send).with(:delete) do |&block|
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

      allow(response).to receive(:status).and_return(204)
      allow(response).to receive(:body).and_return("")

      result = described_class.delete(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: "rev_123",
        confirm_delete: true
      )
      expect(result).to be_nil
    end

    it "includes a null expectedRevisionId when provided" do
      expect(connection).to receive(:send).with(:delete) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq({ "expectedRevisionId" => nil })
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(204)
      allow(response).to receive(:body).and_return("")

      described_class.delete(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        expected_revision_id: nil
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

    it "makes a POST request to insert a node after another node" do
      expected_body = {
        expectedRevisionId: "rev_123",
        insertMode: "after",
        nodeTypeName: "TimerAction",
        fromNodeId: "node_a"
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
        insert_mode: "after",
        node_type_name: "TimerAction",
        from_node_id: "node_a"
      )
      expect(result).to eq({ "node" => { "id" => "node_c" } })
    end

    it "makes a POST request to insert a node before another node using to_node_id" do
      expected_body = {
        expectedRevisionId: "rev_123",
        insertMode: "before",
        nodeTypeName: "TimerAction",
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
        insert_mode: "before",
        node_type_name: "TimerAction",
        to_node_id: "node_b"
      )
      expect(result).to eq({ "node" => { "id" => "node_c" } })
    end

    it "makes a POST request to insert a node before another node using before_node_id" do
      expected_body = {
        expectedRevisionId: "rev_123",
        insertMode: "before",
        nodeTypeName: "TimerAction",
        beforeNodeId: "node_b"
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
        insert_mode: "before",
        node_type_name: "TimerAction",
        before_node_id: "node_b"
      )
      expect(result).to eq({ "node" => { "id" => "node_c" } })
    end

    it "raises when required node IDs are missing for between" do
      expect {
        described_class.create_node(
          workflow_id: "cls9t2u4v0210rx20jpuary23",
          expected_revision_id: "rev_123",
          insert_mode: "between",
          node_type_name: "TimerAction",
          from_node_id: "node_a"
        )
      }.to raise_error(ArgumentError, 'from_node_id and to_node_id are required when insert_mode is "between".')
    end

    it "raises when from_node_id is provided for before" do
      expect {
        described_class.create_node(
          workflow_id: "cls9t2u4v0210rx20jpuary23",
          expected_revision_id: "rev_123",
          insert_mode: "before",
          node_type_name: "TimerAction",
          from_node_id: "node_a",
          to_node_id: "node_b"
        )
      }.to raise_error(ArgumentError, 'from_node_id is not permitted when insert_mode is "before".')
    end

    it "raises when both to_node_id and before_node_id are provided for before" do
      expect {
        described_class.create_node(
          workflow_id: "cls9t2u4v0210rx20jpuary23",
          expected_revision_id: "rev_123",
          insert_mode: "before",
          node_type_name: "TimerAction",
          to_node_id: "node_b",
          before_node_id: "node_b"
        )
      }.to raise_error(ArgumentError, 'Provide either to_node_id or before_node_id when insert_mode is "before", not both.')
    end

    it "raises when to_node_id is provided for after" do
      expect {
        described_class.create_node(
          workflow_id: "cls9t2u4v0210rx20jpuary23",
          expected_revision_id: "rev_123",
          insert_mode: "after",
          node_type_name: "TimerAction",
          from_node_id: "node_a",
          to_node_id: "node_b"
        )
      }.to raise_error(ArgumentError, 'to_node_id is not permitted when insert_mode is "after".')
    end

    it "raises for an unknown insert_mode" do
      expect {
        described_class.create_node(
          workflow_id: "cls9t2u4v0210rx20jpuary23",
          expected_revision_id: "rev_123",
          insert_mode: "around",
          node_type_name: "TimerAction"
        )
      }.to raise_error(ArgumentError, 'insert_mode must be "between", "before", or "after".')
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

  describe ".reroute_node" do
    it "makes a POST request to reroute a node connection" do
      expected_body = {
        expectedRevisionId: "rev_123",
        newTargetNodeId: "cln3c5d7e9f1g3h5i7j9k1l3"
      }

      expect(connection).to receive(:send).with(:post) do |&block|
        req = double("req")
        expect(req).to receive(:url).with("v1/workflows/cls9t2u4v0210rx20jpuary23/nodes/clt0u3v5w0232sy31kqvbzs34/reroute")
        expect(req).to receive(:headers=).with(default_headers)
        expect(req).to receive(:params=).with({})
        expect(req).to receive(:body=) do |body|
          expect(JSON.parse(body)).to eq(JSON.parse(expected_body.to_json))
        end
        block.call(req)
        response
      end

      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('{"id":"clt0u3v5w0232sy31kqvbzs34","workflowRevisionId":"rev_124"}')

      result = described_class.reroute_node(
        workflow_id: "cls9t2u4v0210rx20jpuary23",
        node_id: "clt0u3v5w0232sy31kqvbzs34",
        expected_revision_id: "rev_123",
        new_target_node_id: "cln3c5d7e9f1g3h5i7j9k1l3"
      )
      expect(result).to eq({ "id" => "clt0u3v5w0232sy31kqvbzs34", "workflowRevisionId" => "rev_124" })
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
