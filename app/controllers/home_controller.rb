class HomeController < ApplicationController
  def top
    review_select = 7
    item_select = 10
    select_period = 48 # 過去48時間以内のレビューを抽出する
    from = Time.zone.now - select_period.hour
    to = Time.zone.now

    # いいねとコメントの総合スコアが高いものを抽出
    popular_reviews_all = Review.where.not(id: @current_user.block_ids).order(['field(id, ?)', Review.popular_ids])
    @popular_reviews = popular_reviews_all.limit(review_select)

    # 指定期間内のレビューのうち、総合スコアが高いものを抽出
    @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)

    # スコアの合計点が高いものを抽出
    @popular_items = Item.order(['field(id, ?)', Item.popular_ids]).limit(item_select)
    @digest_length = 60
    @most_used_tag = ActsAsTaggableOn::Tag.order(taggings_count: :desc).first.name
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
