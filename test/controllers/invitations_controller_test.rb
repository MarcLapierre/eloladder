require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @league = leagues(:super_adventure_club)
    @user_league_owner = users(:league_owner)
    @user_invited = users(:with_pending_invitation)
    @email = users(:without_invitations).email
    @invitation_pending = invitations(:pending)
  end

  test "#show redirects to login page if user is not logged in" do
    get invitation_path(@invitation_pending)
    assert_redirected_to new_user_session_path
  end

  test "#show shows the invitation" do
    sign_in @user_invited
    get invitation_path(@invitation_pending)
    assert_response :success
  end

  test "#show redirects to leagues#index with an error if token is invalid" do
    sign_in @user_invited

    get invitation_path(id: 'invalidtoken')
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
  end

  test "#show redirects to leagues#index with an error if invitation is not pending" do
    sign_in @user_invited
    ['accepted', 'declined'].each do |state|
      @invitation_pending.update_attributes!(state: state)

      get invitation_path(@invitation_pending)
      assert_redirected_to leagues_path

      follow_redirect!
      assert_select "div.flash>div.error"
    end
  end

  test "#create redirects to login page if user is not logged in" do
    post invitations_path, params: { league_id: @league.id, email: @email }
    assert_redirected_to new_user_session_path
  end

  test "#create creates an invitation" do
    sign_in @user_league_owner

    assert_difference 'Invitation.count', 1 do
      post invitations_path, params: { league_id: @league.id, email: @email }
    end
  end

  test "#create redirects to leagues#show with a notice" do
    sign_in @user_league_owner

    post invitations_path, params: { league_id: @league.id, email: @email }
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash>div.notice"
  end

  test "#create redirects to leagues#show with an error if creation fails but league is valid" do
    sign_in @user_league_owner

    post invitations_path, params: { league_id: @league.id }
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash>div.error"
  end

  test "#create redirects to leagues#index with an error if creation fails and league is invalid" do
    sign_in @user_league_owner

    post invitations_path, params: nil
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
  end

  test "#create redirects to leagues#show with an error if an invitation already exists for the email and league" do
    sign_in @user_league_owner

    post invitations_path, params: { league_id: @league.id, email: @user_invited.email }
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash>div.error"
  end

  test "#accept redirects to login page if user is not logged in" do
    post invitation_accept_path(@invitation_pending)
    assert_redirected_to new_user_session_path
  end

  test "#accept accepts an invitation" do
    sign_in @user_invited

    post invitation_accept_path(@invitation_pending)
    @invitation_pending.reload

    assert_equal 'accepted', @invitation_pending.state
  end

  test "#accept sets the user on the invitation" do
    sign_in @user_invited

    post invitation_accept_path(@invitation_pending)
    @invitation_pending.reload
    assert_equal @user_invited, @invitation_pending.user
  end

  test "#accept redirects to leagues#show with a notice" do
    sign_in @user_invited

    post invitation_accept_path(@invitation_pending)
    assert_redirected_to league_path(@invitation_pending.league)

    follow_redirect!
    assert_select "div.flash>div.notice"
  end

  test "#accept redirects to leagues#index with an error if token is invalid" do
    sign_in @user_invited

    post invitation_accept_path(token: 'invalid')
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
  end

  test "#decline redirects to login page if user is not logged in" do
    post invitation_decline_path(@invitation_pending)
    assert_redirected_to new_user_session_path
  end

  test "#decline declines an invitation" do
    sign_in @user_invited

    post invitation_decline_path(@invitation_pending)
    @invitation_pending.reload

    assert_equal 'declined', @invitation_pending.state
  end

  test "#decline sets the user on the invitation" do
    sign_in @user_invited

    post invitation_decline_path(@invitation_pending)
    @invitation_pending.reload
    assert_equal @user_invited, @invitation_pending.user
  end

  test "#decline redirects to leagues#index with a notice" do
    sign_in @user_invited

    post invitation_decline_path(@invitation_pending)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.notice"
  end

  test "#decline redirects to leagues#index with an error if token is invalid" do
    sign_in @user_invited

    post invitation_decline_path(token: 'invalid')
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
  end
end
