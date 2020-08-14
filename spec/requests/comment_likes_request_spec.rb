require 'rails_helper'

RSpec.describe "CommentLikes", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#create" do
    before do
      @comment = FactoryBot.create(:comment)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # Topページにリダイレクトされること
      it "redirects to top" do
        login_rspec admin
        post "/comment_likes?comment_id=#{@comment.id}"
        expect(response).to redirect_to('/')
        expect(response).to have_http_status "302"
      end
    end
  end
end
