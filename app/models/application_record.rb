class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(keyword)
    class_name = name
    search = "%" + keyword + "%"
    return where('content like ?', search) if class_name == "Review"
    return where('name like ?', search) if class_name == "Category"
    return where('name like ?', search) if class_name == "Manufacturer"
    return where('name like ?', search) if class_name == "User"

    Item.eager_load(:manufacturer, :category, :tags).where('items.title like ? or
                                                             items.content like ? or
                                                             manufacturers.name like ? or
                                                             categories.name like ? or
                                                             tags.name like ?', search, search, search, search, search)
  end
end
