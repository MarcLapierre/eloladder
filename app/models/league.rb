class League < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :rules, presence: true
  validates :user, presence: true
end
