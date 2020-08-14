class WantToEatItemsController < ApplicationController
  before_action :authenticate_user
  before_action :restrict_admin

  def create
    @item = Item.find(params[:item_id])
    WantToEatItem.create(user_id: @current_user.id, item_id: @item.id)
    @count = params[:count].to_i + 1

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @item = Item.find(params[:id])
    WantToEatItem.find_by(user_id: @current_user.id, item_id: params[:id]).destroy
    @count = params[:count].to_i - 1

    respond_to do |format|
      format.js
    end
  end
end
