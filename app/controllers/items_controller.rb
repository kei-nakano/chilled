class ItemsController < ApplicationController
  def index
    return @items = Item.all.tagged_with(params[:tag]) if params[:tag]

    @items = Item.all.order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
    @score = @item.average_score.round(1)
    return @reviews = @item.reviews.where.not(id: @current_user.block_ids) unless params[:review_id]

    @first_review = Review.find(params[:review_id])
    @other_reviews = @item.reviews.where.not(id: @first_review.id).where.not(id: @current_user.block_ids)
    @first_comment = Comment.find(params[:comment_id]) if params[:comment_id]
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "作成しました"
      redirect_to("/items")
    else
      render('new')
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:notice] = "保存しました"
      redirect_to("/items")
    else
      render 'edit'
    end
  end

  def destroy
    Item.find(params[:id]).destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/items")
  end

  private

  def item_params
    params.require(:item).permit(
      :title, :content, :image, :tag_list, :manufacturer_id, :category_id
    )
  end
end
