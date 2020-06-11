class ReviewLikesController < ApplicationController
  def create
    @review = Review.find(params[:review_id])
    ReviewLike.create(user_id: @current_user.id, review_id: @review.id)
    @review.create_notice_review_like(@current_user)
    @count = params[:count].to_i + 1

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @review = Review.find(params[:review_id])
    ReviewLike.find_by(user_id: @current_user.id, review_id: params[:review_id]).destroy
    @count = params[:count].to_i - 1

    respond_to do |format|
      format.js
    end
  end
end
