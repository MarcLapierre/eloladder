require 'test_helper'

class League::UpdateTest < ActiveSupport::TestCase
  def setup
    @league = leagues(:super_adventure_club)
  end

  test "call succeeds" do
    op = League::Update.new(params)
    op.call
    assert op.succeeded?
  end

  test "call sets league parameters to the expected values" do
    league = League::Update.call(params)
    assert_equal params[:name], league.name
    assert_equal params[:description], league.description
    assert_equal params[:rules], league.rules
    assert_equal params[:website_url], league.website_url
    assert_equal params[:logo_url], league.logo_url
  end

  test "call does not update missing fields" do
    old_name = @league.name
    params.delete(:name)
    op = League::Update.new(params)
    op.call
    assert_equal old_name, op.output.name
  end

  test "call does not update nil fields" do
    old_name = @league.name
    op = League::Update.new(params.merge(name: nil))
    op.call
    assert_equal old_name, op.output.name
  end

  test "call halts if the league is not persisted" do
    op = League::Update.new(params.merge(league: League.new))
    op.call
    assert op.halted?
  end

  test "call returns the unpersisted league object when halting" do
    op = League::Update.new(params.merge(league: League.new))
    op.call
    assert op.output.is_a?(League)
    refute op.output.persisted?
    assert op.output.errors[:league]
  end

  private

  def params
    @params ||= {
      league: @league,
      name: 'Updated League Name',
      description: 'Updated League Description',
      rules: 'Updated League Rules',
      website_url: 'http://my.site.com/updated',
      logo_url: 'http://img.g.ca/my_updated_img.png'
    }.symbolize_keys!
  end
end
