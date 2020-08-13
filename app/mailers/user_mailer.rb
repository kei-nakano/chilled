class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "メールアドレス確認のお願い"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワード再設定のお願い"
  end
end
