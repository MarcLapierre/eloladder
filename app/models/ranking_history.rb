class RankingHistory < ApplicationRecord
  belongs_to :league
  belongs_to :player
  belongs_to :opponent, class_name: 'Player', foreign_key: 'opponent_id'

  validates :league, presence: true
  validates :player, presence: true
  validates :opponent, presence: true
  validates :ranking_before, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ranking_after, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :opponent_ranking_before, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :opponent_ranking_after, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :score, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :opponent_score, presence: true, numericality: { only_integer: true, greater_than: 0 }
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
