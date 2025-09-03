require "rails_helper"

RSpec.describe Tools::RegistryService do
  let(:service) { described_class.new }

  # Dummy tool class for testing purposes
  let(:active_tool_class) do
    Class.new do
      def initialize(params = {}); end
      def name; "active_tool"; end
      def to_registry_format; { name: "active_tool", type: "function" }; end
      def active?; true; end
    end
  end

  let(:inactive_tool_class) do
    Class.new do
      def initialize(params = {}); end
      def name; "inactive_tool"; end
      def to_registry_format; { name: "inactive_tool", type: "function" }; end
      def active?; false; end
    end
  end

  describe "#initialize" do
    it "initializes with an empty tools hash" do
      expect(service.tools).to be_empty
    end

    it "initializes with an empty registered_tools array" do
      expect(service.registered_tools).to be_empty
    end
  end

  describe "#register_tool" do
    context "when the tool is active" do
      it "adds the tool to the tools hash" do
        service.register_tool(active_tool_class)
        expect(service.tools["active_tool"]).to be_an_instance_of(active_tool_class)
      end

      it "adds the tool's registry format to the registered_tools array" do
        service.register_tool(active_tool_class)
        expect(service.registered_tools).to include({ name: "active_tool", type: "function" })
      end
    end

    context "when the tool is not active" do
      it "does not add the tool to the tools hash" do
        service.register_tool(inactive_tool_class)
        expect(service.tools).to be_empty
      end

      it "does not add the tool to the registered_tools array" do
        service.register_tool(inactive_tool_class)
        expect(service.registered_tools).to be_empty
      end
    end

    context "when registering a tool with params" do
      it "initializes the tool with the given params" do
        tool_params = { api_key: "12345" }
        expect(active_tool_class).to receive(:new).with(tool_params).and_call_original
        service.register_tool(active_tool_class, tool_params)
      end
    end
  end
end