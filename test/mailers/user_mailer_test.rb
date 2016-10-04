require 'test_helper'

class UserMailerTest < ActiveSupport::TestCase
  def setup
    @invitation = invitations(:pending)
  end

  test "invitation_email" do
    email = UserMailer.invitation_email(@invitation).deliver_now
    refute ActionMailer::Base.deliveries.empty?

    assert_equal [@invitation.email], email.to
    assert_equal "You've been invited to join #{@invitation.league.name}", email.subject
    assert_match(/You've been invited to join #{@invitation.league.name}/, email.encoded)
    assert_match(/#{Rails.application.routes.url_helpers.invitation_path(@invitation)}/, email.encoded)
  end
end
