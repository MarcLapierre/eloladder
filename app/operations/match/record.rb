class Match::Record < ActiveOperation::Base
  input :league, accepts: League, type: :keyword, required: true
  input :player, accepts: Player, type: :keyword, required: true
  input :opponent, accepts: Player, type: :keyword, required: true
  input :player_score, accepts: Integer, type: :keyword, required: true
  input :opponent_score, accepts: Integer, type: :keyword, required: true

  before do
    halt :player_league   unless player.league == league
    halt :opponent_league unless opponent.league == league
    halt :player_score    unless player_score >= 0
    halt :opponent_score  unless opponent_score >= 0
  end

  def execute
    ActiveRecord::Base.transaction(requires_new: true) do
      match = Match.create!(
        league: league,
        player: player,
        opponent: opponent,
        player_score: player_score,
        opponent_score: opponent_score
      )
      RatingHistory.create!(
        match: match,
        player: player,
        opponent: opponent,
        rating_before: player.rating,
        rating_after: new_stats[:player][:rating],
        opponent_rating_before: opponent.rating,
        opponent_rating_after: new_stats[:opponent][:rating],
        outcome: get_outcome(player_score, opponent_score)
      )
      RatingHistory.create!(
        match: match,
        player: opponent,
        opponent: player,
        rating_before: opponent.rating,
        rating_after: new_stats[:opponent][:rating],
        opponent_rating_before: player.rating,
        opponent_rating_after: new_stats[:player][:rating],
        outcome: get_outcome(opponent_score, player_score)
      )
      player.update!(
        rating: new_stats[:player][:rating],
        pro: new_stats[:player][:pro]
      )
      opponent.update!(
        rating: new_stats[:opponent][:rating],
        pro: new_stats[:opponent][:pro]
      )
      match
    end
  end

  private

  def new_stats
    @new_stats ||= begin
      elo_player = Elo::Player.new(games_played: player.games_played, rating: player.rating, pro: player.pro)
      elo_opponent = Elo::Player.new(games_played: opponent.games_played, rating: opponent.rating, pro: opponent.pro)

      if player_score > opponent_score
        elo_player.wins_from(elo_opponent)
      elsif opponent_score > player_score
        elo_player.loses_from(elo_opponent)
      else
        elo_player.plays_draw(elo_opponent)
      end

      {
        player: {
          rating: elo_player.rating,
          pro: elo_player.pro?
        },
        opponent: {
          rating: elo_opponent.rating,
          pro: elo_opponent.pro?
        }
      }
    end
  end

  def get_outcome(player_score, opponent_score)
    return "tied" if player_score == opponent_score
    return "won"  if player_score > opponent_score
    return "lost" if player_score < opponent_score
    nil
  end
end
