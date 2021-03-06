require "test_helper"

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user_league_owner = users(:league_owner)
    @user_with_pending_invitation = users(:with_pending_invitation)
    @league = leagues(:super_adventure_club)
    @player = players(:league_owner_sac)
    @opponent = players(:opponent)
    @email = users(:without_invitations).email
  end

  test "#index redirects to login page if user is not logged in" do
    get leagues_path
    assert_redirected_to new_user_session_path
  end

  test "#index is accessible if user is signed in" do
    sign_in @user_league_owner
    get leagues_path
    assert_response :success
    assert_template 'index'
  end

  test "#index shows the user's leagues if he has any" do
    sign_in @user_league_owner
    get leagues_path

    @user_league_owner.leagues.each do |league|
      assert_select ".leagues .name", { text: league.name }
    end
  end

  test "#index shows no leagues message if user has no leagues" do
    sign_in @user_with_pending_invitation
    get leagues_path

    assert_select "div.empty-text"
  end

  test "#new redirects to login page if user is not logged in" do
    get new_league_path
    assert_redirected_to new_user_session_path
  end

  test "#new is accessible if user is signed in" do
    sign_in @user_league_owner
    get new_league_path
    assert_response :success
    assert_template 'new'
  end

  test "#new shows the create league form" do
    sign_in @user_league_owner
    get new_league_path
    assert_select "form.new_league"
  end

  test "#create redirects to login page if user is not logged in" do
    post leagues_path, params: { league: league_params }
    assert_redirected_to new_user_session_path
  end

  test "#create creates a league" do
    sign_in @user_league_owner

    assert_difference 'League.count', 1 do
      post leagues_path, params: { league: league_params }
    end
  end

  test "#create redirects to leagues#show" do
    sign_in @user_league_owner

    post leagues_path, params: { league: league_params }
    assert_redirected_to league_path(League.last)
  end

  test "#create renders #new with errors if creation fails" do
    sign_in @user_league_owner

    post leagues_path, params: { league: league_params.merge!(name: nil) }
    assert_template 'new'
    assert_select "form>blockquote"
  end

  test "#show redirects to login page if user is not logged in" do
    get league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "#show redirects to leagues#index if user is not in the league" do
    sign_in @user_with_pending_invitation
    get league_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#show is accessible if user is signed in and is in the league" do
    sign_in @user_league_owner
    get league_path(@league)
    assert_response :success
    assert_template 'show'
  end

  test "#edit redirects to login page if user is not logged in" do
    get edit_league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "#edit redirects to leagues#index if user doesn't own the league" do
    sign_in @user_with_pending_invitation
    get edit_league_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#edit is accessible if user is signed in and owns the league" do
    sign_in @user_league_owner
    get edit_league_path(@league)
    assert_response :success
    assert_template 'edit'
  end

  test "#edit shows the edit league form" do
    sign_in @user_league_owner
    get edit_league_path(@league)
    assert_select "form.edit_league"
  end

  test "#update redirects to login page if user is not logged in" do
    put league_path(@league), params: { league: league_params.merge!(name: 'Updated') }
    assert_redirected_to new_user_session_path
  end

  test "#update redirects index page with error if the user does not own the league" do
    sign_in @user_with_pending_invitation
    put league_path(@league), params: { league: league_params.merge!(name: 'Updated') }
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#update updates a league" do
    sign_in @user_league_owner

    put league_path(@league), params: { league: league_params.merge!(name: 'Updated') }

    @league.reload
    assert_equal 'Updated', @league.name
  end

  test "#update redirects to leagues#show" do
    sign_in @user_league_owner

    put league_path(@league), params: { league: league_params }
    assert_redirected_to league_path(@league)
  end

  test "#update renders edit with errors if update fails" do
    sign_in @user_league_owner

    put league_path(@league), params: { league: league_params.merge(name: '') }
    assert_template 'edit'
    assert_select "form>blockquote"
  end

  test "#enter_match_result redirects to login page if user is not logged in" do
    get league_enter_match_result_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "#enter_match_result redirects to leagues#index if user is not in the league" do
    sign_in @user_with_pending_invitation
    get league_enter_match_result_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#enter_match_result is accessible if user is signed in and is in the league" do
    sign_in @user_league_owner
    get league_enter_match_result_path(@league)
    assert_response :success
    assert_template 'enter_match_result'
  end

  test "#enter_match_result redirects to the league page with an error if there is only one player" do
    @league.players.where.not(id: @player.id).delete_all
    sign_in @user_league_owner
    get league_enter_match_result_path(@league)
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'show'
  end

  test "#add_match_result redirects to login page if user is not logged in" do
    post league_add_match_result_path(@league), params: add_match_result_params
    assert_redirected_to new_user_session_path
  end

  test "#add_match_result redirects to leagues#index if user is not in the league" do
    sign_in @user_with_pending_invitation
    post league_add_match_result_path(@league), params: add_match_result_params
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#add_match_result redirects to league#show with notice" do
    sign_in @user_league_owner
    post league_add_match_result_path(@league), params: add_match_result_params
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash.notice"
    assert_template 'show'
  end

  test "#add_match_result creates rating histories for both users" do
    sign_in @user_league_owner
    assert_difference 'RatingHistory.count', 2 do
      assert_difference '@player.rating_histories.count', 1 do
        assert_difference '@opponent.rating_histories.count', 1 do
          post league_add_match_result_path(@league), params: add_match_result_params
        end
      end
    end
  end

  test "#add_match_result updates user statistics" do
    sign_in @user_league_owner
    assert_difference '@player.reload.rating', 20 do
      assert_difference '@opponent.reload.rating', -20 do
        assert_difference '@player.reload.games_played', 1 do
          assert_difference '@opponent.reload.games_played', 1 do
            post league_add_match_result_path(@league), params: add_match_result_params
          end
        end
      end
    end
  end

  test "#add_match_result redirects to leagues#index with error if player is not in the league" do
    sign_in @user_with_pending_invitation
    post league_add_match_result_path(@league), params: add_match_result_params
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#add_match_result redirects to leagues#show with error if opponent is not in the league" do
    sign_in @user_league_owner
    post league_add_match_result_path(@league), params: { opponent_id: players(:league_owner_ac).id, player_score: 2, opponent_score: 1 }
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'show'
  end

  test "#invite redirects to login page if user is not logged in" do
    post league_invite_path(@league), params: { email: @email }
    assert_redirected_to new_user_session_path
  end

  test "#invite redirects to leagues#index if user doesn't own the league" do
    sign_in @user_with_pending_invitation
    post league_invite_path(@league), params: { email: @email }
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash.error"
    assert_template 'index'
  end

  test "#invite creates an invitation" do
    sign_in @user_league_owner

    assert_difference 'Invitation.count', 1 do
      post league_invite_path(@league), params: { email: @email }
    end
  end

  test "#invite redirects to leagues#show with a notice" do
    sign_in @user_league_owner

    post league_invite_path(@league), params: { email: @email }
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash.notice"
  end

  test "#invite redirects to leagues#show with an error if creation fails" do
    sign_in @user_league_owner

    post league_invite_path(@league), params: nil
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash.error"
  end

  test "#invite redirects to leagues#show with an error if an invitation already exists for the email" do
    sign_in @user_league_owner

    post league_invite_path(@league), params: { email: @user_with_pending_invitation.email }
    assert_redirected_to league_path(@league)

    follow_redirect!
    assert_select "div.flash.error"
  end

  private

  def league_params
    {
      name: 'Test League',
      description: 'This is a description',
      rules: 'These are the rules',
      website_url: nil,
      logo_url: nil
    }
  end

  def add_match_result_params
    { 
      opponent_id: @opponent.id,
      player_score: 2,
      opponent_score: 1
    }
  end
end
