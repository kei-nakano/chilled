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

  # 一般ユーザが管理者機能にアクセスした場合、直前のページにリダイレクトさせる
  def restrict_user
    redirect_back(fallback_location: "/users/#{@current_user.id}") unless @current_user.admin?
  end

  # 管理者ユーザで実行できない機能にアクセスした場合、直前のページにリダイレクトさせる
  def restrict_admin
    return nil unless @current_user.admin?

    flash[:notice] = "管理者ユーザーでは利用できません"
    redirect_back(fallback_location: "/")
  end
end
