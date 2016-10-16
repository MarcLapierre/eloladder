require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:league_owner)
    @user_not_in_league = users(:with_pending_invitation)
    @league = leagues(:super_adventure_club)
    @player = players(:league_owner_sac)
  end

  test "#show redirects to login page if user is not logged in" do
    get player_path(@player)
    assert_redirected_to new_user_session_path
  end

  test "#show redirects to leagues#index if user is not in the league" do
    sign_in @user_not_in_league
    get player_path(@player)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#show is accessible if user is signed in and is in the league" do
    sign_in @user
    get player_path(@player)
    assert_response :success
    assert_template 'show'
  end
end