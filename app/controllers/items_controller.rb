class ItemsController < ApplicationController
  def index
    @items = Item.all.order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
    @score = @item.average_score.round(1)
    return @reviews = @item.reviews unless params[:review_id]

    @first_review = Review.find(params[:review_id])
    @other_reviews = @item.reviews.where.not(id: @first_review.id)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(title: params[:item][:title], user_id: @current_user.id)
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
    @item.title = params[:item][:title]
    if @item.save
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
end
