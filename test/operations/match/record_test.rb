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
    assert_difference '@player.reload.rating', 12 do
      assert_difference '@opponent.reload.rating', -13 do
        Match::Record.call(params)
      end
    end
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

  test "does not record match results if any of the commits fail" do
    @opponent.expects(:update!).raises(ActiveRecord::StatementInvalid.new("error"))
    assert_no_difference '@player.reload.games_played' do
      assert_no_difference '@opponent.reload.games_played' do
        assert_no_difference '@player.reload.rating' do
          assert_no_difference '@opponent.reload.rating' do
            assert_no_difference 'RatingHistory.count' do
              assert_raise 'ActiveRecord::StatementInvalid' do
                Match::Record.call(params)
              end
            end
          end
        end
      end
    end
  end

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
