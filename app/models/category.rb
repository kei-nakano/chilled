class Category < ApplicationRecord
  has_many :items, dependent: :destroy
end
