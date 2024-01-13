class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  has_many :images, dependent: :destroy
  validates :title, presence: true
  scope :live, -> { where(live: true) }
  acts_as_nested_set

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
