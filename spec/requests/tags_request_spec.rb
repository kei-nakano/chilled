require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }

  describe "destroy" do
    before do
      @review = FactoryBot.create(:review, :with_tags)
      @tag = @review.tags.first
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # 削除できること
      it "can destory a tag" do
        login_rspec admin
        expect do
          delete "/tags/#{@tag.id}"
        end.to change(@review.tags, :count).by(-1)

        expect(response).to redirect_to('/search?type=tag')
        expect(response).to have_http_status "302"
      end
    end

    # 一般ユーザの場合
    context "as a user" do
      # プロフィールへリダイレクトされること
      it "redirects to profile" do
        login_rspec user
        delete "/tags/#{@tag.id}"
        expect(response).to redirect_to user
        expect(response).to have_http_status "302"
      end
    end
  end
end
