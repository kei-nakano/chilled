require 'rails_helper'

RSpec.describe "ReviewLikes", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#create" do
    before do
      @review = FactoryBot.create(:review)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # Topページにリダイレクトされること
      it "redirects to top" do
        login_rspec admin
        post "/review_likes?review_id=#{@review.id}"
        expect(response).to redirect_to('/')
        expect(response).to have_http_status "302"
      end
    end
  end
end
