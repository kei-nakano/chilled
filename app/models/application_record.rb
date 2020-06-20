class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(keyword)
    class_name = name
    search = "%" + keyword + "%"
    return where('content like ?', search) if class_name == "Review"
    return where('name like ?', search) if class_name.in?(%w[Category User Manufacturer])

    Item.eager_load(:manufacturer, :category).where('items.title like ? or
                                                             items.content like ? or
                                                             manufacturers.name like ? or
                                                             categories.name like ?', search, search, search, search)
  end
end
