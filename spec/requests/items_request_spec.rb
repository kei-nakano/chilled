require 'rails_helper'

RSpec.describe "Items", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:manufacturer) { FactoryBot.create(:manufacturer) }
  let(:category) { FactoryBot.create(:category) }

  describe "#show" do
    # 未ログインの場合
    context "not login" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        item = FactoryBot.create(:item)
        get "/items/#{item.id}"
        expect(response).to be_successful
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        item = FactoryBot.create(:item)
        get "/items/#{item.id}"
        expect(response).to have_http_status "200"
      end
    end

    context "as a user" do
      # 正常にレスポンスを返すこと
      it "responds successfully" do
        login_rspec user
        item = FactoryBot.create(:item)
        get "/items/#{item.id}"
        expect(response).to be_successful
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        login_rspec user
        item = FactoryBot.create(:item)
        get "/items/#{item.id}"
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    # 管理者ユーザの場合
    context "as an admin" do
      before do
        login_rspec(admin)
      end

      # 有効な属性値の場合
      context "with valid attributes" do
        # 商品が作成できること
        it "creates an item" do
          item_params = FactoryBot.attributes_for(:item, manufacturer_id: manufacturer.id, category_id: category.id)

          expect do
            post "/items", params: { item: item_params }
          end.to change(Item.all, :count).by(1)

          expect(response).to redirect_to "/items/#{Item.first.id}"
          expect(response).to have_http_status "302"
        end
      end
    end

    # 一般ユーザの場合
    context "as a user" do
      before do
        login_rspec(user)
      end

      # 商品が作成できないこと
      it "can not create an item" do
        item_params = FactoryBot.attributes_for(:item, manufacturer_id: manufacturer.id, category_id: category.id)

        expect do
          post "/items", params: { item: item_params }
        end.to change(Item.all, :count).by(0)

        expect(response).to redirect_to user
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#update" do
    # 管理者ユーザの場合
    context "as an admin" do
      before do
        login_rspec(admin)
      end

      # 有効な属性値の場合
      context "with valid attributes" do
        # 商品が修正できること
        it "updates an item" do
          item1 = FactoryBot.create(:item)
          item_params = FactoryBot.attributes_for(:item, manufacturer_id: manufacturer.id, category_id: category.id)

          expect do
            patch "/items/#{item1.id}", params: { item: item_params }
          end.to change(Item.all, :count).by(0)

          expect(response).to redirect_to "/items/#{item1.id}"
          expect(response).to have_http_status "302"
        end
      end
    end
  end

  describe "#destory" do
    # 管理者ユーザの場合
    context "as an admin" do
      before do
        login_rspec(admin)
      end

      # 商品が削除できること
      it "destroys an item" do
        item1 = FactoryBot.create(:item)

        expect do
          delete "/items/#{item1.id}"
        end.to change(Item.all, :count).by(-1)

        expect(response).to redirect_to "/search"
        expect(response).to have_http_status "302"
      end
    end
  end
end
