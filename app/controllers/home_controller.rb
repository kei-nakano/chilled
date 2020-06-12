class HomeController < ApplicationController
  def top
    @reviews = Review.where.not(id: @current_user.block_ids)
    @items = Item.all
    @digest_length = 60
    @most_used_tag = ActsAsTaggableOn::Tag.order(taggings_count: :desc).first.name
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
