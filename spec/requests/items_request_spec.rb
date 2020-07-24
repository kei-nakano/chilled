require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "#show" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      item = FactoryBot.create(:item)
      get "/items/#{item.id}"
      expect(response).to be_successful
    end

    # 200レスポンスを返すこと
    it "returns a 200 response" do
      item = FactoryBot.create(:item)
      get "/items/#{item.id}"
      expect(response).to have_http_status "200"
    end
  end
end
