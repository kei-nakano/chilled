class HomeController < ApplicationController
  def top
    review_select = 7
    item_select = 10
    
    # 人気のレビューとして、いいねとコメントの総合スコアが高いものを抽出
    @popular_reviews = Review.where.not(id: @current_user.block_ids).where(id: Review.popular_ids).limit(review_select)
    
    @recent_reviews = Review.where.not(id: @current_user.block_ids).order(created_at: :desc).limit(review_select)
    @items = Item.all.limit(item_select)
    @digest_length = 60
    @most_used_tag = ActsAsTaggableOn::Tag.order(taggings_count: :desc).first.name
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
