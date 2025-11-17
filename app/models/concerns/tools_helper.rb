module ToolsHelper
  extend ActiveSupport::Concern

  class_methods do
    # Returns all available agent tools with their metadata.
    # Only includes tools that have corresponding class files and can be resolved.
    #
    # @return [Array<Hash>] Array of tool hashes with :id, :title, :description, :icon
    def available_agent_tools
      @available_agent_tools ||= load_agent_tools
    end

    # Resolves a tool class from a tool ID.
    # Converts snake_case tool IDs to PascalCase class names and constantizes them.
    #
    # @param tool_id [String] The snake_case tool identifier
    # @return [Class, nil] The tool class if found, nil if not resolvable
    def resolve_tool_class(tool_id)
      # E.g: Llm::Tools::HandoffTool
      class_name = "Llm::Tools::#{tool_id.classify}Tool"
      class_name.safe_constantize
    end

    # Returns an array of all available tool IDs.
    # Convenience method that extracts just the IDs from available_agent_tools.
    #
    # @return [Array<String>] Array of available tool IDs
    def available_tool_ids
      @available_tool_ids ||= available_agent_tools.map { |tool| tool[:id] }
    end

    private

    # Loads agent tools from the YAML configuration file.
    # Filters out tools that cannot be resolved to actual classes.
    #
    # @return [Array<Hash>] Array of resolvable tools with metadata
    # @api private
    def load_agent_tools
      tools_config = YAML.load_file(Rails.root.join("config/agents/tools.yml"))

      tools_config.filter_map do |tool_config|
        tool_class = resolve_tool_class(tool_config["id"])

        if tool_class
          {
            id: tool_config["id"],
            title: tool_config["title"],
            description: tool_config["description"]
          }
        else
          Rails.logger.warn "Tool class not found for ID: #{tool_config['id']}"
          nil
        end
      end
    end
  end
end
