require 'test_helper'

class Invitation::CreateTest < ActiveSupport::TestCase
  def setup
    @league = leagues(:super_adventure_club)
    @user_with_no_invitation = users(:chef)
    @user_with_invitation = users(:tom)
    @email = "address_without_a_user@example.com"
  end

  test "call succeeds" do
    op = Invitation::Create.new(league: @league, email: @email)
    op.call
    assert op.succeeded?
  end

  test "an invitation defaults to pending state" do
    invitation = Invitation::Create.call(league: @league, email: @email)
    assert_equal 'pending', invitation.state
  end

  test "an invitation can be created for a non-existing user" do
    assert_difference 'Invitation.count', 1 do
      Invitation::Create.call(league: @league, email: @email)
    end
  end

  test "an invitation can be created for an existing user" do
    assert_difference 'Invitation.count', 1 do
      Invitation::Create.call(league: @league, email:  @user_with_no_invitation.email)
    end
  end

  test "an invitation can't be created if one already exists for a user and league" do
    assert_no_difference 'Invitation.count' do
      Invitation::Create.call(league: @league, email:  @user_with_invitation.email)
    end
  end

  test "an invitation can't be created if one already exists for an email and league" do
    Invitation::Create.call(league: @league, email: @email)
    assert_no_difference 'Invitation.count' do
      Invitation::Create.call(league: @league, email: @email)
    end
  end
end
