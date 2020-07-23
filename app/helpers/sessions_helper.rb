module SessionsHelper
  # 渡されたユーザーでログインする
  def login(user)
    session[:user_id] = user.id
  end

  # 現在のユーザーをログアウトする
  def logout(user)
    forget user
    session.delete(:user_id)
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # before_action等による強制リダイレクト後に元々のリクエストURLへ飛べるよう、sessionにパスを記録する
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # フレンドリーフォーワード
  def friendly_forward(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
end
