class LikesController < ApplicationController
  def create
    Like.create(user_id: @current_user.id, item_id: params[:item_id])
    redirect_to "/items/#{params[:item_id]}"
  end

  def destroy
    Like.find_by(user_id: @current_user.id, item_id: params[:item_id]).destroy
    redirect_to "/items/#{params[:item_id]}"
  end
end
