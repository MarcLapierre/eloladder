require 'test_helper'

class Invitation::DeclineTest < ActiveSupport::TestCase
  def setup
    @user = users(:chef)
    @league = leagues(:super_adventure_club)
    @invitation = create_invitation(@user.email, @league)
  end

  test "call succeeds" do
    op = Invitation::Decline.new(token: @invitation.token, user: @user)
    op.call
    assert op.succeeded?
  end

  test "declining an invitation changes its state to pending" do
    invitation = Invitation::Decline.call(token: @invitation.token, user: @user)
    assert_equal 'declined', invitation.state
  end

  test "declining an invitation sets declined_at" do
    Timecop.freeze do
      invitation = Invitation::Decline.call(token: @invitation.token, user: @user)
      assert_equal Time.now.utc, invitation.declined_at
    end
  end

  test "declining an invitation sets the user" do
    invitation = Invitation::Decline.call(token: @invitation.token, user: @user)
    assert_equal @user, invitation.user
  end

  private

  def create_invitation(email, league)
    Invitation::Create.call(email: email, league: league)
  end
end
