require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  setup do
    @player = players(:league_owner_sac)
    @opponent = players(:opponent)
    @league = leagues(:super_adventure_club)
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

  test "rating defaults to proper default rating" do
    assert_equal Elo.config.default_rating, Player.new.rating
  end

  test "name returns the user's first and last name'" do
    assert_equal "#{@player.user.first_name} #{@player.user.last_name}", @player.name
  end

  test "player rating_histories has a counter cache" do
    assert_nothing_raised do
      @player.rating_histories_count
    end
  end

  test "games_played returns teh number of rating histories" do
    5.times do
      Match::Record.call(player: @player, opponent: @opponent, league: @league, won: true)
      assert_equal @player.rating_histories.count, @player.games_played
    end
  end
end
