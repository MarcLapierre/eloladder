require 'test_helper'

class League::CreateTest < ActiveSupport::TestCase
  def setup
    @user = users(:chef)
  end

  test "call succeeds" do
    op = League::Create.new(params)
    op.call
    assert op.succeeded?
  end

  test "call sets league parameters to the expected values" do
    league = League::Create.call(params)
    assert_equal params[:user], league.user
    assert_equal params[:name], league.name
    assert_equal params[:description], league.description
    assert_equal params[:rules], league.rules
    assert_equal params[:website_url], league.website_url
    assert_equal params[:logo_url], league.logo_url
  end

  test "call creates a player for the user in the league" do
    assert_difference 'Player.count', 1 do
      league = League::Create.call(params)
      player = league.players.find_by(user: @user)
      assert player
      assert_equal 1, league.players.count
    end
  end

  test "call halts if the parameters are not valid" do
    op = League::Create.new(params.merge(user: nil))
    op.call
    assert op.halted?
  end

  test "call returns the unpersisted league object when halting" do
    op = League::Create.new(params.merge(user: nil))
    op.call
    assert op.output.is_a?(League)
    refute op.output.persisted?
    assert op.output.errors[:user]
  end

  private

  def params
    @params ||= {
      user: @user,
      name: 'League Name',
      description: 'League Description',
      rules: 'League Rules',
      website_url: 'http://my.site.com',
      logo_url: 'http://img.g.ca/my_img.png'
    }.symbolize_keys!
  end
end
