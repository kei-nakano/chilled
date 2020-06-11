class CommentLikesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    CommentLike.create(user_id: @current_user.id, comment_id: @comment.id)
    @comment.create_notice_comment_like(@current_user)
    @count = params[:count].to_i + 1

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    CommentLike.find_by(user_id: @current_user.id, comment_id: params[:comment_id]).destroy
    @count = params[:count].to_i - 1

    respond_to do |format|
      format.js
    end
  end
end
