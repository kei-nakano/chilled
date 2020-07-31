class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(keyword)
    class_name = name
    search = "%" + keyword + "%"

    # タグ付けされていないレビューも検索にヒットさせるため、inner joinではなくleft outer joinが必要なため、eager_load
    # レビューの場合は、タグの内容かレビューの内容を対象とする
    return eager_load(:tags).where('reviews.content like ? or tags.name like ?', search, search) if class_name == "Review"

    # tagはApplicationRecordを継承していないため含めない
    return where('name like ?', search) if class_name.in?(%w[Category User Manufacturer])

    # itemの検索範囲は、メーカー名、カテゴリ名、タグ、商品名、商品説明とする
    Item.eager_load(:manufacturer, :category, reviews: :tags).where('items.title like ? or
                                                                     items.content like ? or
                                                                     manufacturers.name like ? or
                                                                     categories.name like ? or
                                                                     tags.name like ?', search, search, search, search, search)
  end
end
