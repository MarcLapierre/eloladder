require 'test_helper'

class Invitation::ClaimTest < ActiveSupport::TestCase
  def setup
    @user = users(:without_invitations)
    @league = leagues(:super_adventure_club)
    @invitation = create_invitation(@user.email, @league)
  end

  test "call succeeds" do
    op = Invitation::Claim.new(user: @user)
    op.call
    assert op.succeeded?
  end

  test "sets the user" do
    Invitation::Claim.call(user: @user)
    assert_equal @user, @invitation.reload.user
  end

  test "raises an error if database update fails" do
    Invitation::ActiveRecord_Relation.any_instance.expects(:update_all).raises(
      ActiveRecord::ActiveRecordError.new("some error")
    )

    assert_raises 'ActiveRecord::ActiveRecordError' do
      Invitation::Claim.call(user: @user)
    end
  end

  private

  def create_invitation(email, league)
    Invitation::Create.call(email: email, league: league)
  end
end
