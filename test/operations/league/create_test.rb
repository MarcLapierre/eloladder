require 'test_helper'

class League::CreateTest < ActiveSupport::TestCase
  def setup
    @user = users(:chef)
    @league = League.new(
      user: @user,
      name: 'League Name',
      description: 'League Description',
      rules: 'League Rules',
      website_url: 'http://my.site.com',
      logo_url: 'http://img.g.ca/my_img.png'
    )
  end

  test "call succeeds" do
    op = League::Create.new(@league)
    op.call
    assert op.succeeded?
  end

  test "call sets league parameters to the expected values" do
    league = League::Create.call(@league)
    assert_equal @league.user, league.user
    assert_equal @league.name, league.name
    assert_equal @league.description, league.description
    assert_equal @league.rules, league.rules
    assert_equal @league.website_url, league.website_url
    assert_equal @league.logo_url, league.logo_url
  end

  test "call creates a player for the user in the league" do
    league = League::Create.call(@league)
    player = league.players.find_by(user: @user)

    refute_nil player
    assert_equal @user, player.user
    assert_equal league, player.league
  end
end
