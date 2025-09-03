require "rails_helper"

RSpec.describe Tools::FromUsdToVesService do
  describe "#execute" do
    let(:service) { described_class.new }
    let(:usd_price) { 10.0 }
    let(:arguments) { { "usd_price" => usd_price }.to_json }
    let(:rate) { 36.5 }
    let(:api_response) { { "promedio" => rate }.to_json }

    before do
      stub_request(:get, "https://ve.dolarapi.com/v1/dolares/oficial")
        .to_return(status: 200, body: api_response, headers: { "Content-Type" => "application/json" })
    end

    context "when a valid usd_price is provided" do
      it "returns the converted price in VES" do
        expect(service.execute(arguments)).to eq((usd_price * rate).round(2))
      end
    end

    context "when usd_price is blank" do
      let(:usd_price) { "" }

      it "returns an error message" do
        expect(service.execute(arguments)).to eq("No `usd_price` provided")
      end
    end

    context "when the API call fails" do
      before do
        stub_request(:get, "https://ve.dolarapi.com/v1/dolares/oficial")
          .to_return(status: 500, body: "Internal Server Error")
      end

      it "returns an error message" do
        expect(service.execute(arguments)).to eq("Error fetching VES rate")
      end
    end
  end
end
