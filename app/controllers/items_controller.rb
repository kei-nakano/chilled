class ItemsController < ApplicationController
  def index
    return @items = Item.all.tagged_with(params[:tag]) if params[:tag]

    @items = Item.all.order(created_at: :desc)
  end

  def show
    @tag_limit = 3
    @item = Item.find(params[:id])
    return @reviews = @item.reviews.where.not(id: block_ids(@current_user)) unless params[:review_id]

    @first_review = Review.find(params[:review_id]) # TOPまたは通知から紹介されたレビューを先頭に表示する
    @other_reviews = @item.reviews.where.not(id: @first_review.id).where.not(id: block_ids(@current_user))
    @first_comment = Comment.find(params[:comment_id]) if params[:comment_id] # 通知から紹介されたコメントを先頭に表示する
  end

  def new
    @item = Item.new
    @manufacturer_list = Manufacturer.all.pluck(:name, :id)
    @category_list = Category.all.pluck(:name, :id)
  end

  def create
    unless params[:item][:manufacturer_id] # メーカー新規作成の場合
      manufacturer = Manufacturer.new(manufacturer_params)
      params[:item][:manufacturer_id] = manufacturer.id if manufacturer.save
    end

    unless params[:item][:category_id] # カテゴリ新規作成の場合
      category = Category.new(category_params)
      params[:item][:category_id] = category.id if category.save
    end

    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "作成しました"
      redirect_to "/items/#{@item.id}"
    else
      manufacturer&.destroy
      category&.destroy
      @manufacturer_list = Manufacturer.all.pluck(:name, :id)
      @category_list = Category.all.pluck(:name, :id)
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
      :title, :manufacturer_id, :category_id, :content, :price, :gram, :calorie, :image
    )
  end

  def manufacturer_params
    params[:manufacturer] = { name: params[:item][:manufacturer_name], image: params[:item][:manufacturer_image] }
    params.require(:manufacturer).permit(
      :name, :image
    )
  end

  def category_params
    params[:category] = { name: params[:item][:category_name], image: params[:item][:category_image] }
    params.require(:category).permit(
      :name, :image
    )
  end
end
