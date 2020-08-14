require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "show" do
    before do
      @admin = FactoryBot.create(:admin)
      @user = FactoryBot.create(:user)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # 管理者プロフィールを表示できること
      it "can display an admin profile" do
        login_rspec @admin
        get "/users/#{@admin.id}"
        expect(response).to have_http_status "200"
      end

      # 一般プロフィールを表示できること
      it "can display a user profile" do
        login_rspec @admin
        get "/users/#{@user.id}"
        expect(response).to have_http_status "200"
      end
    end

    # 一般ユーザの場合
    context "as a user" do
      # 管理者プロフィールを表示できないこと
      it "can not display an admin profile" do
        login_rspec @user
        get "/users/#{@admin.id}"
        expect(response).to have_http_status "404"
      end

      # 一般プロフィールを表示できること
      it "can display a user profile" do
        login_rspec @user
        get "/users/#{@user.id}"
        expect(response).to have_http_status "200"
      end
    end
  end
end
