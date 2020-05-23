class CommentsController < ApplicationController
  before_action :authenticate_user, only: %i[create destroy]

  def new
    @review_id = params[:review_id]
    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = Comment.new(user_id: @current_user.id, review_id: params[:review_id], content: params[:comment][:content])
    @comment.save
    @review_id = params[:review_id]
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment_id = params[:id]
    Comment.find(@comment_id).destroy
    respond_to do |format|
      format.js
    end
  end
end
