class Page < ApplicationRecord
  extend FriendlyId
  belongs_to :user, optional: true
  friendly_id :title, use: %i[slugged history]
  TEMPLATES = %w[article section gallery home].freeze
  has_many :images, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates_inclusion_of :template, in: TEMPLATES
  scope :live, -> {where(live: true)}
  scope :in_menu, -> {where(in_menu: true)}
  # scope :for_url, -> (url){where(url: url)}
  self.implicit_order_column = "lft"
  acts_as_nested_set

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def self.for_url(url)
    Page.where(url: url)
  end
end
