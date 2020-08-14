require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#edit" do
    before do
      @user = FactoryBot.create(:user)
      @category = FactoryBot.create(:category)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # アクセスができること
      it "can edit category" do
        login_rspec admin

        get "/categories/#{@category.id}/edit"
        expect(response).to have_http_status "200"
      end
    end

    # 一般ユーザの場合
    context "as an user" do
      # アクセスができないこと
      it "can not edit category" do
        login_rspec @user

        get "/categories/#{@category.id}/edit"
        expect(response).to redirect_to @user
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#update" do
    before do
      @user = FactoryBot.create(:user)
      @category = FactoryBot.create(:category)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # カテゴリの修正ができること
      it "can update category" do
        login_rspec admin
        category_params = FactoryBot.attributes_for(:category)

        expect do
          patch "/categories/#{@category.id}", params: { category: category_params }
        end.to change(Category.all, :count).by(0)
        expect(response).to redirect_to('/search?type=category')
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#destroy" do
    before do
      @user = FactoryBot.create(:user)
      @category = FactoryBot.create(:category)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # カテゴリの削除ができること
      it "can destroy category" do
        login_rspec admin

        expect do
          delete "/categories/#{@category.id}"
        end.to change(Category.all, :count).by(-1)
        expect(response).to redirect_to('/search?type=category')
        expect(response).to have_http_status "302"
      end
    end
  end
end
