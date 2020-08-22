class AccountActivationsController < ApplicationController
  after_action -> { line_notice("login") }, only: %i[edit]

  # ユーザからのGETリクエストを受けるため、本来であればupdateのところeditアクションを使用
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_columns(activated: true, activated_at: Time.zone.now)
      login user
      flash[:notice] = "アカウントの有効化が完了しました"
      redirect_to "/users/#{user.id}"
    else
      flash[:notice] = "メールのリンクが不正です"
      redirect_to "/"
    end
  end
end
