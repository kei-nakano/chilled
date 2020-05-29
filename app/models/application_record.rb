class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(keyword)
    class_name = name
    search = "%" + keyword + "%"
    return where('name like ?', search) if class_name == "Item"
    # return where('name like ?', search) if class_name == "Category" || "Manufacturer" || "User"
  end
end
