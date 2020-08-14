require 'rails_helper'

RSpec.describe "Blocks", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#create" do
    before do
      @user = FactoryBot.create(:user)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # Topページにリダイレクトされること
      it "redirects to top" do
        login_rspec admin
        post "/blocks?user_id=#{@user.id}"
        expect(response).to redirect_to('/')
        expect(response).to have_http_status "302"
      end
    end
  end
end
