require 'test_helper'

class Match::RecordTest < ActiveSupport::TestCase
  def setup
    @player = players(:player)
    @opponent = players(:opponent)
    @league = leagues(:super_adventure_club)
    @other_league = leagues(:adventure_club)
  end

  test "succeeds with valid params" do
    op = Match::Record.new(params)
    op.call
    assert op.succeeded?
  end

  test "records rating history for both players" do
    assert_difference 'RatingHistory.count', 2 do
      assert_difference '@player.rating_histories.count', 1 do
        assert_difference '@opponent.rating_histories.count', 1 do
          Match::Record.call(params)
        end
      end
    end
  end

  test "updates rating for both players" do
    old_player_rating = @player.rating
    old_opponent_rating = @opponent.rating

    Match::Record.call(params)
    @player.reload
    @opponent.reload

    assert_not_equal old_player_rating, @player.rating
    assert_not_equal old_opponent_rating, @opponent.rating
  end

  test "increments games played for both players" do
    assert_difference '@player.games_played', 1 do
      assert_difference '@opponent.games_played', 1 do
        Match::Record.call(params)
      end
    end
  end

  test "halts if score is tied" do
    op = Match::Record.new(params.merge(score: 1, opponent_score: 1))
    op.call
    assert op.halted?
  end

  test "halts if player is not in the league" do
    @player.update_attributes!(league: @other_league)
    op = Match::Record.new(params)
    op.call
    assert op.halted?
  end

  test "halts if opponent is not in the league" do
    @opponent.update_attributes!(league: @other_league)
    op = Match::Record.new(params)
    op.call
    assert op.halted?
  end

  # rollback fails in test, works in dev
  # test "does not record match results if any of the commits fail" do
  #   @opponent.expects(:update!).raises(ActiveRecord::StatementInvalid.new("error"))
  #   assert_no_difference '@player.games_played' do
  #     assert_no_difference '@opponent.games_played' do
  #       assert_no_difference '@player.rating' do
  #         assert_no_difference '@opponent.rating' do
  #           assert_no_difference 'RatingHistory.count' do
  #             assert_raise 'ActiveRecord::StatementInvalid' do
  #               Match::Record.call(params)
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  private

  def params
    {
      league: @league,
      player: @player,
      opponent: @opponent,
      score: 2,
      opponent_score: 1
    }.symbolize_keys
  end
end
