class ApplicationController < ActionController::Base
  include UsersHelper
  include SessionsHelper
  before_action :set_current_user

  def set_current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)

    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  def authenticate_user
    return if @current_user

    flash[:notice] = "ログインが必要です"
    redirect_to "/login"
  end

  def forbid_login_user
    return unless @current_user

    flash[:notice] = "すでにログインしています"
    redirect_to @current_user
  end
end
