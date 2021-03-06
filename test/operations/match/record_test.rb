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

  test "returns a match" do
    match = Match::Record.call(params)
    assert match.is_a?(Match)
  end

  test "creates a match" do
    assert_difference 'Match.count', 1 do
      Match::Record.call(params)
    end
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
    assert_difference '@player.reload.rating', 20 do
      assert_difference '@opponent.reload.rating', -20 do
        Match::Record.call(params)
      end
    end
  end

  test "sets player pro status if rating goes above 2400" do
    @player.rating = Elo.config.pro_rating_boundry
    Match::Record.call(params)
    assert @player.pro
  end

  test "sets opponent pro status if rating goes above 2400" do
    @opponent.rating = Elo.config.pro_rating_boundry
    Match::Record.call(params.merge(player_score: 0, opponent_score: 1))
    assert @opponent.pro
  end

  test "player pro status does not reset if rating goes below 2400" do
    @player.update_attributes!(rating: Elo.config.pro_rating_boundry + 1, pro: true)
    Match::Record.call(params.merge(player_score: 0, opponent_score: 1))
    assert @player.pro
  end

  test "opponent pro status does not reset if rating goes below 2400" do
    @opponent.update_attributes!(rating: Elo.config.pro_rating_boundry + 1, pro: true)
    Match::Record.call(params)
    assert @opponent.pro
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

  test "match has two rating histories" do
    match = Match::Record.call(params)
    assert_equal 2, match.rating_histories.count
    assert_equal @player, match.rating_histories.first.player
    assert_equal @opponent, match.rating_histories.first.opponent
  end

  private

  def params
    {
      league: @league,
      player: @player,
      opponent: @opponent,
      player_score: 2,
      opponent_score: 1
    }
  end
end
