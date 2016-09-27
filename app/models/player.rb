class Player < ApplicationRecord
  belongs_to :user
  belongs_to :league

  validates :user, presence: true
  validates :league, presence: true
  validates :rating, presence: true
  validates :pro, inclusion: [true, false]
end
