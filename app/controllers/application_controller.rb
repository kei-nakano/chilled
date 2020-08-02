class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_current_user

  def set_current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)

    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  # 未ログインユーザをログインページへリダイレクトさせる
  def authenticate_user
    return if @current_user

    flash[:notice] = "ログインが必要です"
    store_location # 希望のurlを保存しておく
    redirect_to "/login"
  end

  # 既にログイン済みのユーザがユーザ作成を行う場合に、ユーザページへリダイレクトさせる
  def forbid_login_user
    return unless @current_user

    flash[:notice] = "すでにログインしています"
    redirect_to @current_user
  end

  # 自分以外のユーザの情報を編集しようとした場合、自身のページにリダイレクトさせる
  def ensure_correct_user
    return if @current_user.id == params[:id].to_i

    flash[:notice] = "権限がありません"
    redirect_to @current_user
  end

  # 管理者権限がない場合、topページにリダイレクトさせる
  def admin_user
    redirect_to "/" unless @current_user.admin?
  end
end
