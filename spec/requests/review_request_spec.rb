require 'rails_helper'

RSpec.describe "Review", type: :request do
  describe "#new" do
    before do
      @item = FactoryBot.create(:item)
      @user = FactoryBot.create(:user)
    end

    # 未ログインユーザの場合
    context "as an unauthenticated user" do
      # ログインページにリダイレクトされること
      it "redirects to login" do
        get "/reviews/new?item_id=#{@item.id}"
        expect(response).to redirect_to('/login')
        expect(response).to have_http_status "302"
      end
    end

    # ログイン済みユーザの場合
    context "as an authenticated user" do
      before do
        # login userの代替
        # ActionDispatch::Requestクラスの全インスタンスに対して、sessionメソッドが呼ばれた場合に、user_idを返す
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ user_id: @user.id })
      end

      # 正常にレスポンスを返すこと
      it "responds successfully after login" do
        get "/reviews/new?item_id=#{@item.id}"
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#create" do
    before do
      @item = FactoryBot.create(:item)
      @user = FactoryBot.create(:user)
    end

    # 未ログインユーザの場合
    # context "as an unauthenticated user" do
    #  # ログインページにリダイレクトされること
    #  it "redirects to login" do
    #    get "/reviews/new?item_id=#{@item.id}"
    #    expect(response).to redirect_to('/login')
    #    expect(response).to have_http_status "302"
    #  end
    # end

    # ログイン済みユーザの場合
    context "as an authenticated user" do
      before do
        sign_in(@user)
      end

      # 有効な属性値の場合
      context "with valid attributes" do
        # 商品レビューが作成できること
        it "adds a review" do
          review_params = FactoryBot.attributes_for(:review, user_id: @user.id, item_id: @item.id)

          expect do
            post "/reviews", params: { review: review_params }
          end.to change(@user.reviews, :count).by(1)

          expect(response).to redirect_to "/items/#{@item.id}?review_id=#{@user.reviews.first.id}"
          expect(response).to have_http_status "302"
        end
      end

      # 無効な属性値の場合
      context "with invalid attributes" do
        # 商品レビューが作成できること
        it "does not add a review" do
          review_params = FactoryBot.attributes_for(:review, user_id: @user.id, item_id: @item.id, content: nil)

          expect do
            post "/reviews", params: { review: review_params }
          end.to change(@user.reviews, :count).by(0)

          expect(response).to render_template('reviews/new')
          expect(response).to have_http_status "200"
        end
      end
    end
  end

  describe "#update" do
    before do
      @item = FactoryBot.create(:item)
      @user = FactoryBot.create(:user)
      @review = FactoryBot.create(:review)
    end

    # 未ログインユーザの場合
    # context "as an unauthenticated user" do
    #  # ログインページにリダイレクトされること
    #  it "redirects to login" do
    #    get "/reviews/new?item_id=#{@item.id}"
    #    expect(response).to redirect_to('/login')
    #    expect(response).to have_http_status "302"
    #  end
    # end

    # ログイン済みユーザの場合
    context "as an authenticated user" do
      before do
        # login userの代替
        # ActionDispatch::Requestクラスの全インスタンスに対して、sessionメソッドが呼ばれた場合に、user_idを返す
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ user_id: @user.id })
      end

      # 商品レビューが更新できること
      it "updates a review" do
        review_params = FactoryBot.attributes_for(:review, :with_tags)

        expect do
          patch "/reviews/#{@review.id}", params: { review: review_params }
        end.to change(@user.reviews, :count).by(0)

        expect(response).to redirect_to "/items/#{@review.item.id}?review_id=#{@review.id}"
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#destroy" do
    before do
      @item = FactoryBot.create(:item)
      @user = FactoryBot.create(:user)
      @review = FactoryBot.create(:review, user: @user)
    end

    # 未ログインユーザの場合
    # context "as an unauthenticated user" do
    #  # ログインページにリダイレクトされること
    #  it "redirects to login" do
    #    get "/reviews/new?item_id=#{@item.id}"
    #    expect(response).to redirect_to('/login')
    #    expect(response).to have_http_status "302"
    #  end
    # end

    # ログイン済みユーザの場合
    context "as an authenticated user" do
      before do
        sign_in @user
      end

      # 自分の商品レビューが削除できること
      it "destroys a review" do
        expect do
          delete "/reviews/#{@review.id}"
        end.to change(@user.reviews, :count).by(-1)

        expect(response).to redirect_to "/items/#{@review.item.id}"
        expect(response).to have_http_status "302"
      end
    end
  end
end
