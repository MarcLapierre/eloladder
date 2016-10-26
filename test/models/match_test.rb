require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  def setup
    @player = players(:player)
    @opponent = players(:opponent)
    @match = matches(:player_opponent_1)
    @other_league = leagues(:adventure_club)
  end

  test "valid when all fields are present" do
    assert @match.valid?
  end

  test "league is required" do
    @match.league = nil
    refute @match.valid?
  end

  test "player is required" do
    @match.player = nil
    refute @match.valid?
  end

  test "opponent is required" do
    @match.opponent = nil
    refute @match.valid?
  end

  test "player_score is required" do
    @match.player_score = nil
    refute @match.valid?
  end

  test "opponent_score is required" do
    @match.opponent_score = nil
    refute @match.valid?
  end

  test "player must be in the league" do
    @player.update_attributes!(league: @other_league)
    refute @match.valid?
  end

  test "opponent must be in the league" do
    @opponent.update_attributes!(league: @other_league)
    refute @match.valid?
  end
end
