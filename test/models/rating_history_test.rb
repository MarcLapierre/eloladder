require 'test_helper'

class RatingHistoryTest < ActiveSupport::TestCase
  def setup
    @player = players(:player)
    @opponent = players(:opponent)
    @history = rating_histories(:player_1)
    @other_league = leagues(:adventure_club)
  end

  test "valid when all fields are present" do
    assert @history.valid?
  end

  test "league is required" do
    @history.league = nil
    refute @history.valid?
  end

  test "player is required" do
    @history.player = nil
    refute @history.valid?
  end

  test "opponent is required" do
    @history.opponent = nil
    refute @history.valid?
  end

  test "rating_before is required" do
    @history.rating_before = nil
    refute @history.valid?
  end

  test "rating_after is required" do
    @history.rating_after = nil
    refute @history.valid?
  end

  test "opponent_rating_before is required" do
    @history.opponent_rating_before = nil
    refute @history.valid?
  end

  test "opponent_rating_after is required" do
    @history.opponent_rating_after = nil
    refute @history.valid?
  end

  test "score is required" do
    @history.score = nil
    refute @history.valid?
  end

  test "opponent_score is required" do
    @history.opponent_score = nil
    refute @history.valid?
  end

  test "won is required" do
    @history.won = nil
    refute @history.valid?
  end

  test "player must be in the league" do
    @player.update_attributes!(league: @other_league)
    refute @history.valid?
  end

  test "opponent must be in the league" do
    @opponent.update_attributes!(league: @other_league)
    refute @history.valid?
  end
end
