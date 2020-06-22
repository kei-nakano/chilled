class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(keyword)
    class_name = name
    search = "%" + keyword + "%"

    # 検索時にinner joinではなくleft outer joinが必要なため、eager_load
    return eager_load(:tags).where('reviews.content like ? or tags.name like ?', search, search) if class_name == "Review"
    return where('name like ?', search) if class_name.in?(%w[Category User Manufacturer]) # tagはApplicationRecordを継承していないため含めない

    Item.eager_load(:manufacturer, :category, reviews: :tags).where('items.title like ? or
                                                                     items.content like ? or
                                                                     manufacturers.name like ? or
                                                                     categories.name like ? or 
                                                                     tags.name like ?', search, search, search, search, search)
  end
end
