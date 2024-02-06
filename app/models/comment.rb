class Comment < ApplicationRecord
  belongs_to :user
  self.implicit_order_column = "lft"
  acts_as_nested_set
end
