class ReviewsController < ApplicationController
  before_action :modify_tags, only: %i[create update]
  before_action :authenticate_user
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
    @review = Review.find_by(id: params[:id])
    @item = @review.item
  end

  def update
    @review = Review.find_by(id: params[:id])
    @item = @review.item
    if @review.update(review_params)
      flash[:notice] = "変更しました"
      redirect_to "/items/#{@item.id}?review_id=#{@review.id}"
    else
      flash.now[:notice] = "更新に失敗しました"
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
      :content, :score, :item_id, :user_id, :tag_list, { multiple_images: [] }
    )
  end

  # tag_listの中の空白を全て取り除く
  def modify_tags
    params[:review][:tag_list] = params[:review][:tag_list].gsub(/[[:space:]]/, '')
  end
end
