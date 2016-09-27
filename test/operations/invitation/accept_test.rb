require 'test_helper'

class Invitation::AcceptTest < ActiveSupport::TestCase
  def setup
    @user = users(:chef)
    @league = leagues(:super_adventure_club)
    @invitation = create_invitation(@user.email, @league)
  end

  test "call succeeds" do
    op = Invitation::Accept.new(token: @invitation.token, user: @user)
    op.call
    assert op.succeeded?
  end

  test "accepting an invitation changes its state to pending" do
    invitation = Invitation::Accept.call(token: @invitation.token, user: @user)
    assert_equal 'accepted', invitation.state
  end

  test "accepting an invitation sets accepted_at" do
    Timecop.freeze do
      invitation = Invitation::Accept.call(token: @invitation.token, user: @user)
      assert_equal Time.now.utc, invitation.accepted_at
    end
  end

  test "accepting an invitation sets the user" do
    invitation = Invitation::Accept.call(token: @invitation.token, user: @user)
    assert_equal @user, invitation.user
  end

  private

  def create_invitation(email, league)
    Invitation::Create.call(email: email, league: league)
  end
end
