class CommentsController < ApplicationController
  before_action :authenticate_user, only: %i[create destroy]

  def new
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def create
    Comment.create!(user_id: @current_user.id, review_id: params[:review_id], content: params[:comment][:content])
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
