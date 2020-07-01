class PasswordResetsController < ApplicationController
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]
  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:notice] = "パスワード再設定のメールを送信しました"
      redirect_to "/"
    else
      flash.now[:notice] = "メールアドレスが見つかりません"
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      login @user
      @user.update_attribute(:reset_digest, nil) # メールを無効化する
      flash[:notice] = "パスワードを再設定しました"
      redirect_to "/users/#{@user.id}"
    else
      @user.errors.add(:password, :blank)
      render 'edit'
    end
  end

  private

  # 正しいユーザーかどうか確認する
  def valid_user
    @user = User.find_by(email: params[:email])
    unless @user&.activated? # ユーザが見つからない or アカウントが有効化されていない
      flash[:notice] = "メールを確認してアカウントの有効化を行ってください"
      return redirect_to "/"
    end

    return if @user.authenticated?(:reset, params[:id]) # メールのリンクのトークンパラメータが一致しない

    flash[:notice] = "メールのリンクが不正です"
    redirect_to "/"
  end

  # 期限切れかどうかを確認する
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:notice] = "メールの有効期限が切れています"
    redirect_to "/password_resets/new"
  end
end
