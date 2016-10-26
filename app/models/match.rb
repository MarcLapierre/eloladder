class Match < ApplicationRecord
  belongs_to :league
  belongs_to :player
  belongs_to :opponent, class_name: 'Player', foreign_key: 'opponent_id'

  validates :league, presence: true
  validates :player, presence: true
  validates :opponent, presence: true
  validates :player_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :opponent_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
