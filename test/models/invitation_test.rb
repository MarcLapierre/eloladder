require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  setup do
    @invitation = invitations(:pending)
  end

  test "must have a league" do
    @invitation.league = nil
    refute @invitation.valid?
  end

  test "must have an email" do
    @invitation.email = nil
    refute @invitation.valid?
  end

  test "must have a token" do
    @invitation.token = nil
    refute @invitation.valid?
  end

  test "must have a valid state" do
    @invitation.state = 'foo'
    refute @invitation.valid?
  end
end
