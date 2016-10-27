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

  test "match is required" do
    @history.match = nil
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

  test "outcome must be in the inclusion list" do
    ['won', 'lost', 'tied'].each do |outcome|
      @history.outcome = outcome
      assert @history.valid?
    end

    @history.outcome = 'another value'
    refute @history.valid?
  end
end
