class Player::DaysSincePlayed < ActiveOperation::Base
  input :player, accepts: Player, required: true

  before do
    halt unless player.rating_histories.any?
  end

  def execute
    ((Time.now.utc - player.rating_histories.last.created_at.utc) / 86400).floor
  end
end
