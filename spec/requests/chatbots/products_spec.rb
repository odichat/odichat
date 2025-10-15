require 'rails_helper'

RSpec.describe "Chatbots::Products", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/chatbots/products/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/chatbots/products/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/chatbots/products/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/chatbots/products/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/chatbots/products/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/chatbots/products/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
