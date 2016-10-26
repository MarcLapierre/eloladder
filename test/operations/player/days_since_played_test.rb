require 'test_helper'

class Player::DaysSincePlayedTest < ActiveSupport::TestCase
  def setup
    @player = players(:player)
    @opponent = players(:opponent)
    @league = leagues(:super_adventure_club)
  end

  test "succeeds with valid params" do
    op = Player::DaysSincePlayed.new(@player)
    op.call
    assert op.succeeded?
  end

  test "returns the correct number of days since the player's last game" do
    Match::Record.call(player: @player, opponent: @opponent, league: @league, player_score: 2, opponent_score: 1)
    [37, 42, 69].each do |num_days|
      Timecop.travel(num_days.days) do
        assert_equal num_days, Player::DaysSincePlayed.call(@player)
      end
    end
  end

  test "returns nil if player hasn't played any games" do
    @player.rating_histories.destroy_all
    assert_nil Player::DaysSincePlayed.call(@player)
  end
end