require 'test_helper'

class Player::StreakTest < ActiveSupport::TestCase
  def setup
    @player = players(:player)
    @opponent = players(:opponent)
    @league = leagues(:super_adventure_club)
  end

  test "succeeds with valid params" do
    op = Player::Streak.new(@player)
    op.call
    assert op.succeeded?
  end

  test "returns a positive number if the player is on a winning streak" do
    @player.rating_histories.destroy_all

    5.times do |counter|
      Match::Record.call(player: @player, opponent: @opponent, league: @league, player_score: 2, opponent_score: 1)
      @player.rating_histories.reload
      assert_equal counter + 1, Player::Streak.call(@player)
    end
  end

  test "returns a negative number if the player is on a losing streak" do
    @player.rating_histories.destroy_all

    5.times do |counter|
      Match::Record.call(player: @player, opponent: @opponent, league: @league, player_score: 1, opponent_score: 2)
      @player.rating_histories.reload
      assert_equal (counter + 1) * -1, Player::Streak.call(@player)
    end
  end

  test "returns 0 if player hasn't played any games" do
    @player.rating_histories.destroy_all
    assert_equal 0, Player::Streak.call(@player)
  end
end