require 'rails_helper'

RSpec.describe "WantToEatItems", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#create" do
    before do
      @item = FactoryBot.create(:item)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # Topページにリダイレクトされること
      it "redirects to top" do
        login_rspec admin
        post "/want_to_eat_items?item_id=#{@item.id}"
        expect(response).to redirect_to('/')
        expect(response).to have_http_status "302"
      end
    end
  end
end
