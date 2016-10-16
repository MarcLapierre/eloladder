class Player < ApplicationRecord
  after_initialize :init, unless: :persisted?

  belongs_to :user
  belongs_to :league
  has_many :rating_histories

  validates :user, presence: true
  validates :league, presence: true
  validates :rating, presence: true
  validates :games_played, presence: true
  validates :pro, inclusion: [true, false]
  validates :owner, inclusion: [true, false]

  def init
    self.pro = false
    self.rating = Elo.config.default_rating
    self.games_played = 0
  end

  def name
    "#{user.first_name} #{user.last_name}"
  end
end
