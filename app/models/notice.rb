class Notice < ApplicationRecord
  validates :visitor_id, presence: true
  validates :visited_id, presence: true
  validates :action, presence: true
  belongs_to :review, optional: true
  belongs_to :comment, optional: true
  belongs_to :visitor, class_name: 'User', optional: true
  belongs_to :visited, class_name: 'User', optional: true
end
