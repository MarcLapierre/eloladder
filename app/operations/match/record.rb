class Match::Record < ActiveOperation::Base
  input :league, accepts: League, type: :keyword, required: true
  input :player, accepts: Player, type: :keyword, required: true
  input :opponent, accepts: Player, type: :keyword, required: true
  input :score, accepts: Integer, type: :keyword, required: true
  input :opponent_score, accepts: Integer, type: :keyword, required: true

  before do
    halt unless player.league == league && opponent.league == league
    halt if score == opponent_score
  end

  def execute
    ActiveRecord::Base.transaction(requires_new: true) do
      RatingHistory.create!(
        league: league,
        player: player,
        opponent: opponent,
        rating_before: player.rating,
        rating_after: calculate_new_ratings[:player],
        opponent_rating_before: opponent.rating,
        opponent_rating_after: calculate_new_ratings[:opponent],
        score: score,
        opponent_score: opponent_score,
        won: score > opponent_score
      )
      RatingHistory.create!(
        league: league,
        player: opponent,
        opponent: player,
        rating_before: opponent.rating,
        rating_after: calculate_new_ratings[:opponent],
        opponent_rating_before: player.rating,
        opponent_rating_after: calculate_new_ratings[:player],
        score: opponent_score,
        opponent_score: score,
        won: opponent_score > score
      )
      player.update!(games_played: player.games_played + 1, rating: calculate_new_ratings[:player])
      opponent.update!(games_played: opponent.games_played + 1, rating: calculate_new_ratings[:opponent])
    end
  end

  private

  def calculate_new_ratings
    @new_ratings ||= begin
      elo_player = Elo::Player.new(games_played: player.games_played, rating: player.rating, pro: player.pro)
      elo_opponent = Elo::Player.new(games_played: opponent.games_played, rating: opponent.rating, pro: opponent.pro)
      elo_player.versus(elo_opponent, result: score > opponent_score ? 1 : 0)
      { player: elo_player.rating, opponent: elo_opponent.rating }
    end
  end
end
