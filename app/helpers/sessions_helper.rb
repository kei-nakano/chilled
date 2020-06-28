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
end
