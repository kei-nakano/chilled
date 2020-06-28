class SessionsController < ApplicationController
  before_action :forbid_login_user, only: %i[new create]

  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      flash[:notice] = "ログインしました"
      session[:user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      flash.now[:notice] = 'メールアドレスかパスワードに誤りがあります'
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    flash[:notice] = "ログアウトしました"
    redirect_to '/'
  end
end
