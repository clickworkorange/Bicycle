class Page < ApplicationRecord
  extend FriendlyId
  # TODO: strip /page/ from route
  # TODO: include parent slug for child pages
  friendly_id :title, use: :slugged
  has_many :children, class_name: "Page", foreign_key: "parent_id", dependent: :restrict_with_error
  belongs_to :parent, class_name: "Page", optional: true

  def live_children
    self.children.where(live: true)
  end
end
