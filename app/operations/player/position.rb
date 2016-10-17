class Player::Position < ActiveOperation::Base
  input :player, accepts: Player, required: true

  before do
    halt unless player.rating_histories.any?
  end

  def execute
    player.league.players.where("rating_histories_count > 0 AND rating > #{player.rating}").count + 1
  end
end
