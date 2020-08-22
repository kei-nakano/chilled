class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[show edit update destroy]
  before_action :forbid_login_user, only: %i[new create]
  before_action :ensure_correct_user, only: %i[edit update destroy]
  before_action :hidden_admin_profile, only: %i[show]

  def show
    @user = User.find(params[:id])
    @room_id = @current_user&.room_with(@user)&.id
    @type = params[:type] || "review" # typeの指定がない場合、reviewタブを優先表示するようにする

    if @type == "review"
      @results = @user.reviews.includes(:item)
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "want_to_eat_item"
      item_ids = "SELECT item_id FROM want_to_eat_items WHERE user_id = :user_id"
      @results = Item.where("id IN (#{item_ids})", user_id: @user.id)
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "eaten_item"
      item_ids = "SELECT item_id FROM eaten_items WHERE user_id = :user_id"
      @results = Item.where("id IN (#{item_ids})", user_id: @user.id)
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "liked_review"
      review_ids = "SELECT review_id FROM review_likes WHERE user_id = :user_id"
      @results = Review.where("id IN (#{review_ids})", user_id: @user.id).includes(:item)
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "blocking"
      @results = @user.blocking
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    if @type == "following"
      @results = @user.following
      respond_to do |format|
        format.js
        format.html
      end
      return
    end

    return unless @type == "follower"

    @results = @user.followers
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:notice] = "アカウント有効化のためメールを送信しました"
      redirect_to '/'
    else
      render 'new'
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user&.update(user_params)
      flash[:notice] = "更新しました"
      redirect_to "/users/#{@user.id}"
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user&.destroy
      flash[:notice] = "削除しました"
      redirect_to '/'
      line_notice("logout")
    else
      flash[:notice] = "削除に失敗しました"
      redirect_to "/users/#{@user.id}"
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :image, :password
    )
  end

  # 管理者のプロフィールを見られないようにする
  def hidden_admin_profile
    profile = User.find(params[:id])

    # 管理者以外のプロフィールを表示する場合は、何もしない
    return nil unless profile.admin?

    # ------管理者のプロフィールが選択された場合------

    # 自分が管理者ならば、表示できる
    return nil if @current_user.admin?

    # ------一般ユーザが管理者のプロフィールにアクセスした場合------

    # 404ページを表示させる
    raise ActionController::RoutingError, "管理者のプロフィールへのアクセスです"
  end
end
