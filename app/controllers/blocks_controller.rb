class BlocksController < ApplicationController
  before_action :authenticate_user

  def create
    @user = User.find(params[:user_id])
    @current_user.block(@user)
    @current_user.unfollow(@user)

    @active_notices = @user.active_notices.where(visited_id: @current_user.id)
    @active_notices&.destroy_all
    @passive_notices = @user.passive_notices.where(visitor_id: @current_user.id)
    @passive_notices&.destroy_all

    redirect_to "/users/#{@user.id}"
  end

  def destroy
    @user = User.find(params[:id])
    @current_user.unblock(@user)
    redirect_to "/users/#{@user.id}"
  end
end
