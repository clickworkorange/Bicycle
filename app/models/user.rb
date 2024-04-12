class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :registerable, :confirmable, :validatable, :lockable, :recoverable, :rememberable, :database_authenticatable
  scope :admin, -> {where(admin: true)}
  validates :name, presence: true
  after_create do
    NotificationMailer.with(user: self).registration_notfication.deliver_later
  end
end
