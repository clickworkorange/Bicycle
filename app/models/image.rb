class Image < ApplicationRecord
  belongs_to :page
  has_one_attached :image_file
  validates :image_file, presence: true

  # TODO: sort order, ordered scope
end
