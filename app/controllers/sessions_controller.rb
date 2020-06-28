class SessionsController < ApplicationController
  before_action :forbid_login_user, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      login user
      remember user
      flash[:notice] = "ログインしました"
      redirect_to "/users/#{user.id}"
    else
      flash.now[:notice] = 'メールアドレスかパスワードに誤りがあります'
      render 'new'
    end
  end

  def destroy
    logout @current_user if @current_user
    @current_user = nil
    flash[:notice] = "ログアウトしました"
    redirect_to '/'
  end
end
