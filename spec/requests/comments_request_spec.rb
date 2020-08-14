require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#new" do
    before do
      @user = FactoryBot.create(:user)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # Topページにリダイレクトされること
      it "redirects to top" do
        login_rspec admin
        get "/comments/new"
        expect(response).to redirect_to('/')
        expect(response).to have_http_status "302"
      end
    end
  end
end
