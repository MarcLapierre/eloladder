class RatingHistory < ApplicationRecord
  belongs_to :match
  belongs_to :player, counter_cache: true
  belongs_to :opponent, class_name: 'Player', foreign_key: 'opponent_id'

  validates :match, presence: true
  validates :player, presence: true
  validates :opponent, presence: true
  validates :rating_before, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :rating_after, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :opponent_rating_before, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :opponent_rating_after, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :outcome, inclusion: ['won', 'lost', 'tied']
end
