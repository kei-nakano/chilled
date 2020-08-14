class BlocksController < ApplicationController
  before_action :authenticate_user
  before_action :restrict_admin

  def create
    @user = User.find(params[:user_id])
    @current_user.block(@user)
    @current_user.unfollow(@user)

    @active_notices = @user.active_notices.where(visited_id: @current_user.id)
    @active_notices&.destroy_all
    @passive_notices = @user.passive_notices.where(visitor_id: @current_user.id)
    @passive_notices&.destroy_all

    flash[:notice] = "ブロックしました"
    redirect_to "/users/#{@user.id}"
  end

  def destroy
    @user = User.find(params[:id])
    @current_user.unblock(@user)

    flash[:notice] = "ブロックを解除しました"
    redirect_to "/users/#{@user.id}"
  end
end
