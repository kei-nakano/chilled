class BlocksController < ApplicationController
  before_action :authenticate_user, only: %i[create destroy]

  def create
    @user = User.find(params[:user_id])
    @current_user.block(@user)
    @current_user.unfollow(@user)
  
    @active_notices = @user.active_notices.where(visited_id: @current_user.id)
    @active_notices&.destroy_all
    @passive_notices = @user.passive_notices.where(visitor_id: @current_user.id)
    @passive_notices&.destroy_all
    

    redirect_to @user
    # respond_to do |format|
    #  format.html { redirect_to @user }
    #  format.js
    # end
  end

  def destroy
    @user = User.find(params[:id])
    @current_user.unblock(@user)
    redirect_to @user
    # respond_to do |format|
    #  format.html { redirect_to @user }
    #  format.js
    # end
  end
end
