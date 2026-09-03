# frozen_string_literal: true

module LoopsSdk
  class Workflows < Base
    class << self
      def list(perPage: 20, cursor: nil)
        make_request(method: :get, path: "v1/workflows", params: { perPage: perPage, cursor: cursor })
      end

      def create(name:, description: nil, mailing_list_id: nil)
        body = {
          name: name,
          description: description,
          mailingListId: mailing_list_id
        }.compact
        make_request(method: :post, path: "v1/workflows", body: body)
      end

      def get(workflow_id:)
        make_request(method: :get, path: "v1/workflows/#{workflow_id}")
      end

      def update(workflow_id:, expected_revision_id:, name: nil, description: nil)
        body = {
          expectedRevisionId: expected_revision_id,
          name: name,
          description: description
        }.compact
        # expectedRevisionId may be null for older workflows; always include it
        body[:expectedRevisionId] = expected_revision_id
        make_request(method: :post, path: "v1/workflows/#{workflow_id}", body: body)
      end

      def delete(workflow_id:, expected_revision_id:, confirm_delete: nil)
        body = {
          expectedRevisionId: expected_revision_id,
          confirmDelete: confirm_delete
        }.compact
        # expectedRevisionId may be null for older workflows; always include it
        body[:expectedRevisionId] = expected_revision_id
        make_request(method: :delete, path: "v1/workflows/#{workflow_id}", body: body)
      end

      def change_mailing_list(workflow_id:, expected_revision_id:, mailing_list_id:, dry_run: nil, queued_contact_policy: nil)
        body = {
          expectedRevisionId: expected_revision_id,
          mailingListId: mailing_list_id,
          dryRun: dry_run,
          queuedContactPolicy: queued_contact_policy
        }.compact
        # expectedRevisionId and mailingListId may be null; always include them
        body[:expectedRevisionId] = expected_revision_id
        body[:mailingListId] = mailing_list_id
        make_request(method: :post, path: "v1/workflows/#{workflow_id}/mailing-list", body: body)
      end

      def get_node(workflow_id:, node_id:)
        make_request(method: :get, path: "v1/workflows/#{workflow_id}/nodes/#{node_id}")
      end

      def create_node(
        workflow_id:,
        expected_revision_id:,
        insert_mode:,
        node_type_name:,
        from_node_id: nil,
        to_node_id: nil,
        before_node_id: nil
      )
        body = {
          expectedRevisionId: expected_revision_id,
          insertMode: insert_mode,
          nodeTypeName: node_type_name
        }

        case insert_mode
        when "between"
          raise ArgumentError, "from_node_id and to_node_id are required when insert_mode is \"between\"." if from_node_id.nil? || to_node_id.nil?
          raise ArgumentError, "before_node_id is not permitted when insert_mode is \"between\"." unless before_node_id.nil?

          body[:fromNodeId] = from_node_id
          body[:toNodeId] = to_node_id
        when "before"
          raise ArgumentError, "from_node_id is not permitted when insert_mode is \"before\"." unless from_node_id.nil?
          raise ArgumentError, "Provide either to_node_id or before_node_id when insert_mode is \"before\", not both." if !to_node_id.nil? && !before_node_id.nil?
          raise ArgumentError, "to_node_id or before_node_id is required when insert_mode is \"before\"." if to_node_id.nil? && before_node_id.nil?

          if !to_node_id.nil?
            body[:toNodeId] = to_node_id
          else
            body[:beforeNodeId] = before_node_id
          end
        when "after"
          raise ArgumentError, "from_node_id is required when insert_mode is \"after\"." if from_node_id.nil?
          raise ArgumentError, "to_node_id is not permitted when insert_mode is \"after\"." unless to_node_id.nil?
          raise ArgumentError, "before_node_id is not permitted when insert_mode is \"after\"." unless before_node_id.nil?

          body[:fromNodeId] = from_node_id
        else
          raise ArgumentError, "insert_mode must be \"between\", \"before\", or \"after\"."
        end

        make_request(method: :post, path: "v1/workflows/#{workflow_id}/nodes", body: body)
      end

      def update_node(workflow_id:, node_id:, expected_revision_id:, payload:)
        body = {
          expectedRevisionId: expected_revision_id,
          payload: payload
        }
        make_request(method: :post, path: "v1/workflows/#{workflow_id}/nodes/#{node_id}", body: body)
      end

      def delete_node(workflow_id:, node_id:, expected_revision_id:, dry_run: nil, queued_contact_policy: nil)
        body = {
          expectedRevisionId: expected_revision_id,
          dryRun: dry_run,
          queuedContactPolicy: queued_contact_policy
        }.compact
        body[:expectedRevisionId] = expected_revision_id
        make_request(method: :delete, path: "v1/workflows/#{workflow_id}/nodes/#{node_id}", body: body)
      end

      def add_branch(workflow_id:, node_id:, expected_revision_id:)
        body = { expectedRevisionId: expected_revision_id }
        make_request(method: :post, path: "v1/workflows/#{workflow_id}/nodes/#{node_id}/add-branch", body: body)
      end

      def reroute_node(workflow_id:, node_id:, expected_revision_id:, new_target_node_id:)
        body = {
          expectedRevisionId: expected_revision_id,
          newTargetNodeId: new_target_node_id
        }
        make_request(method: :post, path: "v1/workflows/#{workflow_id}/nodes/#{node_id}/reroute", body: body)
      end

      def delete_node_recursive(workflow_id:, node_id:, expected_revision_id:, dry_run: nil, queued_contact_policy: nil)
        body = {
          expectedRevisionId: expected_revision_id,
          dryRun: dry_run,
          queuedContactPolicy: queued_contact_policy
        }.compact
        body[:expectedRevisionId] = expected_revision_id
        make_request(method: :delete, path: "v1/workflows/#{workflow_id}/nodes/#{node_id}/recursive", body: body)
      end
    end
  end
end
