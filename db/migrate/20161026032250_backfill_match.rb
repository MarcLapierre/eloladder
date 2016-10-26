class BackfillMatch < ActiveRecord::Migration[5.0]
  def change
    rhs = RatingHistory.where(won: true)
    rhs.each do |rh|
      Match.create!(
        league: rh.league,
        player: rh.player,
        opponent: rh.opponent,
        player_score: rh.won ? 2 : 0,
        opponent_score: rh.won ? 0 : 2
      )
    end
  end
end
