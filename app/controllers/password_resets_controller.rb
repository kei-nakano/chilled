class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]
  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:notice] = "Email sent with password reset instructions"
      redirect_to "/"
    else
      flash.now[:notice] = "Email address not found"
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def find_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    redirect_to "/" unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end
end
