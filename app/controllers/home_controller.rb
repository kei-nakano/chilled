class HomeController < ApplicationController
  def top
    @digest_length = 60
    review_select = 7
    @item_select = 10
    select_period = 2
    tag_select = 3
    from = Time.zone.now - select_period.day
    to = Time.zone.now

    # いいねとコメントの総合スコアが高いレビューを抽出
    popular_reviews_all = Review.where.not(id: @current_user.block_ids).order(['field(id, ?)', Review.popular_ids])
    @popular_reviews = popular_reviews_all.limit(review_select)

    # 指定期間内のレビューのうち、総合スコアが高いレビューを抽出
    @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)
    while @recent_reviews.count < review_select
      select_period += 1 # 抽出数が足りない場合は、対象期間を変更する
      from = Time.zone.now - select_period.day
      break if select_period > 10

      @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)
    end

    # スコアの合計点が高い商品を抽出 ※※※※※※※※※※
    @popular_items = Item.where(id: Item.popular_ids).order(['field(id, ?)', Item.popular_ids]).limit(@item_select)

    # 食べた！の降順に商品を抽出
    @eaten_items = Item.order(['field(id, ?)', Item.eaten_ids]).limit(@item_select)

    # 食べてみたい！の降順に商品を抽出
    @want_to_eat_items = Item.order(['field(id, ?)', Item.want_to_eat_ids]).limit(@item_select)

    # 1円あたりの内容量(g)が大きい商品を抽出
    @reasonable_items = Item.order(['field(id, ?)', Item.reasonable_ids]).limit(@item_select)

    # カロリーの昇順に商品を抽出
    @low_calorie_items = Item.order(calorie: :asc).limit(@item_select)

    # 使用頻度の高い順にタグを抽出
    @most_used_tags = ActsAsTaggableOn::Tag.most_used(tag_select)
  end

  def about
    @reviews = Review.all
    @items = Item.all
  end
end
