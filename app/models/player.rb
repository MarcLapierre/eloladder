class Player < ApplicationRecord
  after_initialize :init, unless: :persisted?

  belongs_to :user
  belongs_to :league

  validates :user, presence: true
  validates :league, presence: true
  validates :rating, presence: true
  validates :pro, inclusion: [true, false]
  validates :owner, inclusion: [true, false]

  def init
    self.pro = false
    self.rating = 1500
  end
end
