class HomeController < ApplicationController
  def test; end

  def top
    @reviews = Review.all
    @items = Item.all
    @digest_length = 60
    @most_used_tag = ActsAsTaggableOn::Tag.order(taggings_count: :desc).first.name
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
