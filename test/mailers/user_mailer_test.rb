require 'test_helper'

class UserMailerTest < ActiveSupport::TestCase
  def setup
    @email = 'email@example.com'
    @league_name = 'League Name'
    @token = 'token123'
  end

  test "invitation_email" do
    email = UserMailer.invitation_email(@email, @league_name, @token).deliver_now
    refute ActionMailer::Base.deliveries.empty?

    assert_equal [@email], email.to
    assert_equal "You've been invited to join #{@league_name}", email.subject
    assert_match(/You've been invited to join #{@league_name}/, email.encoded)
    assert_match(/#{@token}/, email.encoded)
  end
end
