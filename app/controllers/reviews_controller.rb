class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @item = Item.find_by(id: params[:item_id])
    @manufacturer_list = Manufacturer.all.pluck(:name, :id)
    @category_list = Category.all.pluck(:name, :id)
  end

  def create
    @review = Review.new(review_params)
    @item = Item.find_by(id: params[:review][:item_id])
    if @review.save
      flash[:notice] = "作成しました"
      redirect_to "/items/#{@item.id}?review_id=#{@review.id}"
    else
      flash.now[:notice] = "作成に失敗しました"
      render 'new'
    end
  end

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

  def destroy
    @review = Review.find_by(id: params[:id])
    if @review&.destroy
      flash[:notice] = "レビューを削除しました"
      redirect_to "/items/#{@review.item_id}"
    else
      flash[:notice] = "削除に失敗しました"
      redirect_to "/items/#{@review.item_id}?review_id=#{@review.id}"
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :content, :score, :item_id, :user_id, { multiple_images: [] }
    )
  end
end
