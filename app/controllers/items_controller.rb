class ItemsController < ApplicationController
  def index
    @items = Item.all.order(created_at: :desc)
  end

  def show
    @item = Item.find_by(id: params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.new(title: params[:item][:title])
    item.save
    redirect_to("/items")
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.title = params[:item][:title]
    redirect_to("/items") if item.save
  end

  def destroy
    item = Item.find(params[:id])
    redirect_to("/items") if item.destroy
  end
end
