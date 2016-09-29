require 'test_helper'

class LeagueTest < ActiveSupport::TestCase
  setup do
    @league = leagues(:super_adventure_club)
  end

  test "league must have a name" do
    @league.name = nil
    refute @league.valid?
  end

  test "league must have a description" do
    @league.description = nil
    refute @league.valid?
  end

  test "league must have rules" do
    @league.rules = nil
    refute @league.valid?
  end
end
