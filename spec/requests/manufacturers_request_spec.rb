require 'rails_helper'

RSpec.describe "Manufacturers", type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  describe "#edit" do
    before do
      @user = FactoryBot.create(:user)
      @manufacturer = FactoryBot.create(:manufacturer)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # アクセスができること
      it "can edit manufacturer" do
        login_rspec admin

        get "/manufacturers/#{@manufacturer.id}/edit"
        expect(response).to have_http_status "200"
      end
    end

    # 一般ユーザの場合
    context "as an user" do
      # アクセスができないこと
      it "can not edit manufacturer" do
        login_rspec @user

        get "/manufacturers/#{@manufacturer.id}/edit"
        expect(response).to redirect_to @user
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#update" do
    before do
      @user = FactoryBot.create(:user)
      @manufacturer = FactoryBot.create(:manufacturer)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # カテゴリの修正ができること
      it "can update manufacturer" do
        login_rspec admin
        manufacturer_params = FactoryBot.attributes_for(:manufacturer)

        expect do
          patch "/manufacturers/#{@manufacturer.id}", params: { manufacturer: manufacturer_params }
        end.to change(Manufacturer.all, :count).by(0)
        expect(response).to redirect_to('/search?type=manufacturer')
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#destroy" do
    before do
      @user = FactoryBot.create(:user)
      @manufacturer = FactoryBot.create(:manufacturer)
    end

    # 管理者ユーザの場合
    context "as an admin" do
      # カテゴリの削除ができること
      it "can destroy manufacturer" do
        login_rspec admin

        expect do
          delete "/manufacturers/#{@manufacturer.id}"
        end.to change(Manufacturer.all, :count).by(-1)
        expect(response).to redirect_to('/search?type=manufacturer')
        expect(response).to have_http_status "302"
      end
    end
  end
end
