class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  has_many :players
  has_many :leagues, through: :players

  validates :first_name, presence: true
  validates :last_name, presence: true
end
