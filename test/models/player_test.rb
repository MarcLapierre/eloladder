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

  test "player must have games_played" do
    @player.games_played = nil
    refute @player.valid?
  end

  test "pro designation defaults to false" do
    refute Player.new.pro?
  end

  test "owner defaults to false" do
    refute Player.new.owner?
  end

  test "rating defaults to proper default rating" do
    assert_equal Elo.config.default_rating, Player.new.rating
  end

  test "games_played defaults to 0" do
    assert_equal 0, Player.new.games_played
  end

  test "name returns the user's first and last name'" do
    assert_equal "#{@player.user.first_name} #{@player.user.last_name}", @player.name
  end
end
