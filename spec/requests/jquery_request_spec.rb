require 'rails_helper'

RSpec.describe "Jqueries", type: :request do
  describe "GET /top" do
    it "returns http success" do
      get "/jquery/top"
      expect(response).to have_http_status(:success)
    end
  end
end
