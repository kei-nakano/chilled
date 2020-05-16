class RelationshipsController < ApplicationController
  before_action :authenticate_user, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    @current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = User.find(params[:followed_id])
    @current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
