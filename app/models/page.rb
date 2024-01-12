class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  has_many :children, class_name: "Page", foreign_key: "parent_id", dependent: :restrict_with_error
  belongs_to :parent, class_name: "Page", optional: true
  has_one_attached :banner
  has_many :images, dependent: :destroy

  validates :title, presence: true

  # TODO: sort order, ordered scope

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def live_children
    # TODO: should this be a scope?
    self.children.where(live: true)
  end
end
