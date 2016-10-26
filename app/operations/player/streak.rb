class Player::Streak < ActiveOperation::Base
  input :player, accepts: Player, required: true

  before do
    halt 0 unless player.rating_histories.any?
  end

  def execute
    streak = 0
    wining_streak = player.rating_histories.last.won
    player.rating_histories.order(created_at: :desc).find_each_with_order do |rh|
      break unless (wining_streak && rh.won) || (!wining_streak && !rh.won)
      streak += 1
    end
    streak * (wining_streak ? 1 : -1)
  end
end
