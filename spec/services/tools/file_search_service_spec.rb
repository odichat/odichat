require "rails_helper"

RSpec.describe Tools::FileSearchService do
  describe "#name" do
    it "returns the correct name" do
      expect(described_class.new.name).to eq("file_search")
    end
  end

  describe "#description" do
    it "returns nil" do
      expect(described_class.new.description).to be_nil
    end
  end

  describe "#parameters" do
    it "returns nil" do
      expect(described_class.new.parameters).to be_nil
    end
  end

  describe "#execute" do
    it "returns nil" do
      expect(described_class.new.execute({})).to be_nil
    end
  end

  describe "#to_registry_format" do
    context "when initialized with a vector_store_id" do
      let(:vector_store_id) { "vs_12345" }
      let(:service) { described_class.new(vector_store_id: vector_store_id) }

      it "returns the correct hash format" do
        expected_format = {
          type: "file_search",
          vector_store_ids: [vector_store_id]
        }
        expect(service.to_registry_format).to eq(expected_format)
      end
    end

    context "when initialized without a vector_store_id" do
      let(:service) { described_class.new }

      it "returns the hash with a nil vector_store_id" do
        expected_format = {
          type: "file_search",
          vector_store_ids: [nil]
        }
        expect(service.to_registry_format).to eq(expected_format)
      end
    end
  end
end
