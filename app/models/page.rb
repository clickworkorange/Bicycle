class Page < ApplicationRecord
  extend FriendlyId
  belongs_to :user, optional: true
  friendly_id :title, use: %i[slugged history]
  TEMPLATES = %w[article section gallery home].freeze
  has_many :images, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates_inclusion_of :template, in: TEMPLATES
  scope :live, -> {where(live: true).order(lft: :asc)}
  scope :in_menu, -> {where(in_menu: true)}
  scope :sections,  -> {where(template: "section").order(lft: :asc)}
  # scope :for_url, -> (url){where(url: url)}
  self.implicit_order_column = "lft"
  acts_as_nested_set

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def self.for_url(url)
    Page.where(url: url)
  end

  # TODO: this date stuff is not elegant
  def page_published_at
    read_attribute(:meta_published_at) || self.created_at
  end

  def page_updated_at
    read_attribute(:meta_updated_at) || self.updated_at
  end

  def page_description
    # TODO: trim to some length (full sentence)
    read_attribute(:meta_description) || self.abstract
  end
end
