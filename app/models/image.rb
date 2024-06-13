class Image < ApplicationRecord
  ROLES = %w[inline banner gallery social].freeze
  belongs_to :page
  acts_as_list scope: :page, touch_on_update: false
  self.implicit_order_column = "position"
  mount_uploader :image_file, ImageFileUploader
  # TODO: pluralise these scopes
  scope :banner, -> {where(role: "banner")}
  scope :inline, -> {where(role: "inline").order(position: :asc)}
  # TODO: merge "gallery" and "inline" scopes
  scope :gallery, -> {where(role: "gallery").order(position: :asc)}
  scope :social, -> {where(role: "social")}
  validates :image_file, presence: true
  validates_inclusion_of :role, in: ROLES
end
