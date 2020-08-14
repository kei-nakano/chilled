class ItemsController < ApplicationController
  before_action :check_params, only: %i[create update]
  # 一般ユーザは閲覧以外不可
  before_action :restrict_user, except: %i[show] 

  def show
    @tag_limit = 3
    @item = Item.find(params[:id])
    return @reviews = @item.reviews.where.not(user_id: @current_user&.block_ids) unless params[:review_id]

    @first_review = Review.find(params[:review_id]) # TOPまたは通知から紹介されたレビューを先頭に表示する
    @other_reviews = @item.reviews.where.not(id: @first_review.id).where.not(user_id: @current_user&.block_ids)
    @first_comment = Comment.find(params[:comment_id]) if params[:comment_id] # 通知から紹介されたコメントを先頭に表示する
  end

  def new
    @item = Item.new
    @manufacturer_list = Manufacturer.all.pluck(:name, :id)
    @category_list = Category.all.pluck(:name, :id)
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "作成しました"
      redirect_to "/items/#{@item.id}"
    else
      rollback
      @manufacturer_list = Manufacturer.all.pluck(:name, :id)
      @category_list = Category.all.pluck(:name, :id)
      flash.now[:notice] = "作成に失敗しました"
      render 'new'
    end
  end

  def edit
    @item = Item.find_by(id: params[:id])
    @manufacturer_list = Manufacturer.all.pluck(:name, :id)
    @category_list = Category.all.pluck(:name, :id)
  end

  def update
    @item = Item.find_by(id: params[:id])
    if @item&.update(item_params)
      flash[:notice] = "更新しました"
      redirect_to "/items/#{@item.id}"
    else
      rollback
      @manufacturer_list = Manufacturer.all.pluck(:name, :id)
      @category_list = Category.all.pluck(:name, :id)
      flash.now[:notice] = "更新に失敗しました"
      render 'edit'
    end
  end

  def destroy
    @item = Item.find_by(id: params[:id])
    if @item&.destroy
      flash[:notice] = "商品を削除しました"
      redirect_to("/search")
    else
      flash[:notice] = "削除に失敗しました"
      redirect_to "/items/#{@item.id}"
    end
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

  # フォームからメーカーやカテゴリを新規作成した場合にレコード作成とparamsのマージを行う
  def check_params
    unless params[:item][:manufacturer_id] # メーカー新規作成の場合
      manufacturer = Manufacturer.new(manufacturer_params)
      params[:item][:manufacturer_id] = manufacturer.id if manufacturer.save
    end

    return if params[:item][:category_id] # カテゴリ新規作成の場合

    category = Category.new(category_params)
    params[:item][:category_id] = category.id if category.save
  end

  # itemの作成・更新に失敗した場合、新規作成したカテゴリとメーカーを削除する
  def rollback
    Manufacturer.find_by(name: params[:item][:manufacturer_name])&.destroy
    Category.find_by(name: params[:item][:category_name])&.destroy
  end
end
