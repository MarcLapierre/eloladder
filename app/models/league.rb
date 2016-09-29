class League < ApplicationRecord
  has_many :players

  validates :name, presence: true
  validates :description, presence: true
  validates :rules, presence: true
end
