class CommentLikesController < ApplicationController
  def create
    CommentLike.create(user_id: @current_user.id, comment_id: params[:comment_id])
    redirect_to "/comments/#{params[:comment_id]}"
  end

  def destroy
    CommentLike.find_by(user_id: @current_user.id, comment_id: params[:comment_id]).destroy
    redirect_to "/comments/#{params[:comment_id]}"
  end
end
