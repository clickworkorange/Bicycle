class Comment < ApplicationRecord
  belongs_to :user
  self.implicit_order_column = "lft"
  acts_as_nested_set
  validates :title, presence: true
  validates :title, length: {maximum: 50}
  validates :body, presence: true
  validates :body, length: {maximum: 500}
end
