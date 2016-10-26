class RatingHistory < ApplicationRecord
  belongs_to :league
  belongs_to :match
  belongs_to :player, counter_cache: true
  belongs_to :opponent, class_name: 'Player', foreign_key: 'opponent_id'

  validates :match, presence: true
  validates :league, presence: true
  validates :player, presence: true
  validates :opponent, presence: true
  validates :rating_before, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rating_after, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :opponent_rating_before, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :opponent_rating_after, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :won, inclusion: [true, false]

  validate :players_in_league

  private

  def players_in_league
    unless player.try(:league) == league
      errors.add(:player, 'not in the league')
    end
    unless opponent.try(:league) == league
      errors.add(:opponent, 'not in the league')
    end
  end
end
