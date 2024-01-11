class Page < ApplicationRecord
  extend FriendlyId
  # TODO: strip /page/ from route
  # TODO: include parent slug for child pages
  friendly_id :title, use: :slugged
  has_many :children, class_name: "Page", foreign_key: "parent_id", dependent: :restrict_with_error
  belongs_to :parent, class_name: "Page", optional: true
  has_one_attached :banner
  has_many :images, dependent: :destroy

  validates :title, presence: true

  def live_children
    # TODO: should this be a scope?
    self.children.where(live: true)
  end
end
