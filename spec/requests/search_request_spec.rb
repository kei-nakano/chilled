require 'rails_helper'

RSpec.describe "Search", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }

  describe "#top" do
    # 未ログイン状態
    context "not login" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        get "/search"
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # 一般ユーザー
    context "as a user" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login_rspec user
        get "/search"
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # 管理者ユーザー
    context "as an admin" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login_rspec admin
        get "/search"
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end
end
