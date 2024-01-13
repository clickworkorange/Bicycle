class Image < ApplicationRecord
  ROLES = ["inline","banner","gallery"]
  belongs_to :page
  acts_as_list scope: :page, touch_on_update: false
  has_one_attached :image_file
  scope :inline, -> { where(role: "inline") }
  scope :gallery, -> { where(role: "gallery") }
  validates :image_file, presence: true
  validates_inclusion_of :role, :in => ROLES

end
