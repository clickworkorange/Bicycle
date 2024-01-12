class Image < ApplicationRecord
  belongs_to :page
  acts_as_list scope: :page, touch_on_update: false
  has_one_attached :image_file
  validates :image_file, presence: true
end
