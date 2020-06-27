class UsersController < ApplicationController
  before_action :authenticate_user, only: %i[show edit update]
  before_action :forbid_login_user, only: %i[new create login_form login]
  before_action :ensure_correct_user, only: %i[edit update]

  def login_form; end

  def login
    @user = User.find_by(email: params[:email])
    if @user.authenticate(params[:password])
      flash[:notice] = "ログインしました"
      session[:user_id] = @user.id
      redirect_to @user
    else
      @error_message = "メールアドレスかパスワードが間違っています"
      render 'login_form'
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to '/login'
  end

  def show
    @user = User.find(params[:id])
    @room_id = @current_user.room_with(@user).id
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

  def blocking
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "登録しました"
      session[:user_id] = @user.id
      redirect_to '/users'
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "削除しました"
    redirect_to '/users'
  end

  def timeline
    @user = User.find(params[:id])
    @items = @user.feed
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :image, :password
    )
  end

  def ensure_correct_user
    return if @current_user.id == params[:id].to_i

    flash[:notice] = "権限がありません"
    redirect_to @current_user
  end
end
