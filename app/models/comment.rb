class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :page
  self.implicit_order_column = "lft"
  acts_as_nested_set
  validates :title, presence: true
  validates :title, length: {maximum: 50}
  validates :body, presence: true
  validates :body, length: {maximum: 500}
  after_create do
    NotificationMailer.with(comment: self).comment_notification.deliver_later
  end
end
