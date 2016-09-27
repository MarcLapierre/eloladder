require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = players(:chef_sac)
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
end
