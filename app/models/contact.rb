class Contact
  include ActiveModel::Model
  attr_accessor :email, :name, :subject, :message
  validates :email, :name, :subject, :message, presence: true
  validates_format_of :email, with: /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i
end