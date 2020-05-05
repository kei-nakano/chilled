require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/items/index"
      expect(response).to have_http_status(:success)
    end
  end
end
