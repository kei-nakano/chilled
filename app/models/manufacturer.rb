class Manufacturer < ApplicationRecord
  has_many :items, dependent: :destroy
end
