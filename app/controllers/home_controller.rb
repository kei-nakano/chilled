class HomeController < ApplicationController
  def top
    @reviews = Review.all
    @items = Item.all
    @digest_length = 60
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
