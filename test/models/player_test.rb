require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = players(:league_owner_sac)
  end

  test "player must have a user" do
    @player.user = nil
    refute @player.valid?
  end

  test "player must have a league" do
    @player.league = nil
    refute @player.valid?
  end

  test "player must have a rating" do
    @player.rating = nil
    refute @player.valid?
  end

  test "player must have a pro designation" do
    @player.pro = nil
    refute @player.valid?
  end

  test "pro designation defaults to false" do
    pro = Player.new.pro?
    assert_equal false, pro
  end

  test "rating defaults to 1500" do
    rating = Player.new.rating
    assert_equal 1500, rating
  end
end
