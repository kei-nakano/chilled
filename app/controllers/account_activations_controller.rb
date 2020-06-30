class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_columns(activated: true, activated_at: Time.zone.now)
      login user
      flash[:notice] = "Account activated!"
      redirect_to "/users/#{user.id}"
    else
      flash[:notice] = "Invalid activation link"
      redirect_to "/"
    end
  end
end
