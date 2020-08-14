class HomeController < ApplicationController
  def top
    @digest_length = 60 # レビューのダイジェスト文の長さ
    @item_select = 7 # スクロール表示する商品の数

    # いいねとコメントの総合スコアが高いレビューを抽出(過去のレビュー全てを対象とする)
    popular_ids = Review.popular_ids
    review_select = 7 # topページに表示するスクロールレビューの数

    # ブロックしているユーザのレビューは除外する
    popular_reviews_all = Review.where(id: popular_ids).order([Arel.sql('field(id, ?)'), popular_ids]).where.not(user_id: @current_user&.block_ids)
    @popular_reviews = popular_reviews_all.limit(review_select)

    # --------------------------------------------------------------------------------

    # 過去3日間のレビューのうち、総合スコアが高いレビューを抽出
    from = Time.zone.now - 3.days
    to = Time.zone.now
    @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)

    # 抽出数が足りない場合は、対象期間を変更する
    limit_period = 7 #  最大でどれだけ前の時間に投稿されたレビューを抽出対象とするか / 3 + 7 = 10日前まで
    select_period = 0
    while @recent_reviews.count < review_select
      select_period += 1
      from = Time.zone.now - select_period.day
      break if select_period > limit_period

      @recent_reviews = popular_reviews_all.where(created_at: from..to).limit(review_select)
    end

    # --------------------------------------------------------------------------------

    # スコアの合計点が高い商品を抽出
    popular_ids = Item.popular_ids
    @popular_items = Item.where(id: Item.popular_ids).where(id: popular_ids).order([Arel.sql('field(id, ?)'), popular_ids]).limit(@item_select)

    # 食べた！の降順に商品を抽出
    eaten_ids = Item.eaten_ids
    @eaten_items = Item.where(id: eaten_ids).order([Arel.sql('field(id, ?)'), eaten_ids]).limit(@item_select)

    # 食べたい！の降順に商品を抽出
    want_to_eat_ids = Item.want_to_eat_ids
    @want_to_eat_items = Item.where(id: want_to_eat_ids).order([Arel.sql('field(id, ?)'), want_to_eat_ids]).limit(@item_select)

    # 1円あたりの内容量(g)が大きい商品を抽出
    reasonable_ids = Item.reasonable_ids
    @reasonable_items = Item.where(id: reasonable_ids).order([Arel.sql('field(id, ?)'), reasonable_ids]).limit(@item_select)

    # カロリーの昇順に商品を抽出
    @low_calorie_items = Item.order(calorie: :asc).limit(@item_select)

    # 使用頻度の高い順にタグを抽出
    tag_select = 3
    @most_used_tags = ActsAsTaggableOn::Tag.most_used(tag_select)
  end
end
