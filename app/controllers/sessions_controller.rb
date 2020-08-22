class SessionsController < ApplicationController
  before_action :forbid_login_user, only: %i[new create]
  after_action -> { line_notice("login") }, only: %i[create]
  before_action -> { line_notice("logout") }, only: %i[destroy] # 可能であれば、destroy後に実施するのが望ましい。改善の余地あり。

  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      if user.activated?
        login user
        params[:remember_me] == '1' ? remember(user) : forget(user)
        flash[:notice] = "ログインしました"
        friendly_forward user
      else
        flash[:notice] = "メールのリンクを確認してアカウントを有効化してください"
        redirect_to "/"
      end
    else
      flash.now[:notice] = 'メールアドレスかパスワードに誤りがあります'
      render 'new'
    end
  end

  def destroy
    logout @current_user if @current_user
    @current_user.update_attribute(:room_id, 0)
    @current_user = nil
    flash[:notice] = "ログアウトしました"
    redirect_to '/'
  end
end
