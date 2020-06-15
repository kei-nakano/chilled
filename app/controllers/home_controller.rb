class HomeController < ApplicationController
  def top
    review_select = 7
    item_select = 10
    @reviews = Review.where.not(id: @current_user.block_ids).limit(review_select)
    @items = Item.all.limit(item_select)
    @digest_length = 60
    @most_used_tag = ActsAsTaggableOn::Tag.order(taggings_count: :desc).first.name
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
