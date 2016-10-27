class Player::Streak < ActiveOperation::Base
  input :player, accepts: Player, required: true

  before do
    halt 0 unless player.rating_histories.any?
    halt 0 if player.rating_histories.last.outcome == 'tied'
  end

  def execute
    streak = 0
    winning_streak = player.rating_histories.last.outcome == 'won'
    player.rating_histories.order(created_at: :desc).find_each_with_order do |rh|
      break unless (winning_streak && rh.outcome == 'won') || (!winning_streak && rh.outcome == 'lost')
      streak += 1
    end
    streak * (winning_streak ? 1 : -1)
  end
end
