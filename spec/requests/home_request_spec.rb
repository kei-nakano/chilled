require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "#top" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      get "/"
      expect(response).to be_successful
    end

    # 200レスポンスを返すこと
    it "returns a 200 response" do
      get "/"
      expect(response).to have_http_status "200"
    end
  end
end
