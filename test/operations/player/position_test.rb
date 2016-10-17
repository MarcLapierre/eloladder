require 'test_helper'

class Player::PositionTest < ActiveSupport::TestCase
  def setup
    @player = players(:player)
  end

  test "succeeds with valid params" do
    op = Player::Position.new(@player)
    op.call
    assert op.succeeded?
  end

  test "returns the correct player position" do
    @player.update_attributes!(rating: 1000000)
    assert_equal 1, Player::Position.call(@player)

    @player.update_attributes!(rating: 0)
    assert_equal @player.league.players.where('rating_histories_count > 0').count, Player::Position.call(@player)
  end

  test "returns nil if player hasn't played any games" do
    @player.rating_histories.destroy_all
    assert_nil Player::Position.call(@player)
  end
end