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

  test "player must have an owner setting" do
    @player.owner = nil
    refute @player.valid?
  end

  test "player must have a pro designation" do
    @player.pro = nil
    refute @player.valid?
  end

  test "pro designation defaults to false" do
    refute Player.new.pro?
  end

  test "owner defaults to false" do
    refute Player.new.owner?
  end

  test "rating defaults to 1500" do
    assert_equal 1500, Player.new.rating
  end
end
