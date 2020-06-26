class HomeController < ApplicationController
  def top
    @digest_length = 60
    review_select = 7
    @item_select = 10
    select_period = 2
    limit_period = 100 #  過去どれだけ前の時間に投稿されたレビューを対象とするか
    tag_select = 3
    from = Time.zone.now - select_period.day
    to = Time.zone.now

    # いいねとコメントの総合スコアが高いレビューを抽出
    popular_ids = Review.popular_ids
    popular_reviews_all = Review.where.not(id: block_ids(@current_user)).where(id: popular_ids).order([Arel.sql('field(id, ?)'), popular_ids])
    @popular_reviews = popular_reviews_all.limit(review_select)

    # 指定期間内のレビューのうち、総合スコアが高いレビューを抽出
    @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)
    while @recent_reviews.count < review_select
      select_period += 1 # 抽出数が足りない場合は、対象期間を変更する
      from = Time.zone.now - select_period.day
      break if select_period > limit_period

      @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)
    end

    # スコアの合計点が高い商品を抽出
    popular_ids = Item.popular_ids
    @popular_items = Item.where(id: Item.popular_ids).where(id: popular_ids).order([Arel.sql('field(id, ?)'), popular_ids]).limit(@item_select)

    # 食べた！の降順に商品を抽出
    eaten_ids = Item.eaten_ids
    @eaten_items = Item.where(id: eaten_ids).order([Arel.sql('field(id, ?)'), eaten_ids]).limit(@item_select)

    # 食べてみたい！の降順に商品を抽出
    want_to_eat_ids = Item.want_to_eat_ids
    @want_to_eat_items = Item.where(id: want_to_eat_ids).order([Arel.sql('field(id, ?)'), want_to_eat_ids]).limit(@item_select)

    # 1円あたりの内容量(g)が大きい商品を抽出
    reasonable_ids = Item.reasonable_ids
    @reasonable_items = Item.where(id: reasonable_ids).order([Arel.sql('field(id, ?)'), reasonable_ids]).limit(@item_select)

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
