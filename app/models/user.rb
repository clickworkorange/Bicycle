class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :registerable, :confirmable, :validatable, :lockable, :recoverable, :rememberable, :reconfirmable, :database_authenticatable
  scope :admin, -> {where(admin: true)}
  validates :name, presence: true
end
