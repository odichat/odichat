class Tools::RegistryService
  attr_reader :tools, :params, :registered_tools

  def initialize(params = {})
    @params = params
    @registered_tools = []
    @tools = {}
  end

  def register_tool(tool_class, params = {})
    tool = tool_class.new(params)
    return unless tool.active?

    @tools[tool.name] = tool
    @registered_tools << tool.to_registry_format
  end
end
