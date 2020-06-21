class ReviewsController < ApplicationController
  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      flash[:notice] = "保存しました"
      redirect_to("/items/#{@review.item_id}?review_id=#{@review.id}")
    else
      render 'edit'
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :content, :image, :score, { multiple_images: [] }
    )
  end
end
