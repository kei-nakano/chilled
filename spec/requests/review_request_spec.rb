require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  describe "#new" do
    # 未ログインユーザでは、ログインページにリダイレクトされること
    it "redirects to login" do
      item = FactoryBot.create(:item)
      get "/reviews/new?item_id=#{item.id}"
      expect(response).to redirect_to('/login')
    end

    # ログイン後、正常にレスポンスを返すこと
    it "responds successfully after login" do
      item = FactoryBot.create(:item)
      user = FactoryBot.create(:user)

      # login userの代替
      # ActionDispatch::Requestクラスの全インスタンスに対して、sessionメソッドが呼ばれた場合に、user.idを返す
      allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ user_id: user.id })

      get "/reviews/new?item_id=#{item.id}"
      expect(response).to be_successful
      expect(response).to have_http_status "200"
    end
  end
end
