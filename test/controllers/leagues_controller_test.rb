require "test_helper"

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user_with_leagues = users(:chef)
    @user_without_leagues = users(:tom)
    @league = leagues(:super_adventure_club)
  end

  test "#index redirects to login page if user is not logged in" do
    get leagues_path
    assert_redirected_to new_user_session_path
  end

  test "#index is accessible if user is signed in" do
    sign_in @user_with_leagues
    get leagues_path
    assert_response :success
    assert_template 'index'
  end

  test "#index shows the user's leagues if he has any" do
    sign_in @user_with_leagues
    get leagues_path

    @user_with_leagues.leagues.each do |league|
      assert_select ".leagues .name", { text: league.name }
    end
  end

  test "#index shows no leagues message if user has no leagues" do
    sign_in @user_without_leagues
    get leagues_path

    assert_select "div.empty-text"
  end

  test "#new redirects to login page if user is not logged in" do
    get new_league_path
    assert_redirected_to new_user_session_path
  end

  test "#new is accessible if user is signed in" do
    sign_in @user_with_leagues
    get new_league_path
    assert_response :success
    assert_template 'new'
  end

  test "#new shows the create league form" do
    sign_in @user_with_leagues
    get new_league_path
    assert_select "form.new_league"
  end

  test "#create redirects to login page if user is not logged in" do
    post leagues_path, params: league_params
    assert_redirected_to new_user_session_path
  end

  test "#create creates a league" do
    sign_in @user_with_leagues

    assert_difference 'League.count', 1 do
      post leagues_path, params: league_params
    end
  end

  test "#create redirects to leagues#show" do
    sign_in @user_with_leagues

    post leagues_path, params: league_params
    assert_redirected_to league_path(League.last)
  end

  test "#create renders #new with errors if creation fails" do
    sign_in @user_with_leagues

    post leagues_path, params: league_params.merge!(name: nil)
    assert_template 'new'
    assert_select "div.flash>div.error"
  end

  test "#show redirects to login page if user is not logged in" do
    get league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "#show redirects to leagues#index if user doesn't own the league" do
    sign_in @user_without_leagues
    get league_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
    assert_template 'index'
  end

  test "#show is accessible if user is signed in and owns the league" do
    sign_in @user_with_leagues
    get league_path(@league)
    assert_response :success
    assert_template 'show'
  end

  test "#show shows the league details" do
    sign_in @user_with_leagues
    get league_path(@league)
    assert_select "a[href=\"#{@league.website_url}\"]"
  end

  test "#edit redirects to login page if user is not logged in" do
    get edit_league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "#edit redirects to leagues#index if user doesn't own the league" do
    sign_in @user_without_leagues
    get edit_league_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
    assert_template 'index'
  end

  test "#edit is accessible if user is signed in and owns the league" do
    sign_in @user_with_leagues
    get edit_league_path(@league)
    assert_response :success
    assert_template 'edit'
  end

  test "#edit shows the edit league form" do
    sign_in @user_with_leagues
    get edit_league_path(@league)
    assert_select "form.edit_league"
  end

  test "#update redirects to login page if user is not logged in" do
    put league_path(@league), params: { league: league_params.merge!(name: 'Updated') }
    assert_redirected_to new_user_session_path
  end

  test "#update redirects index page with error if the user does not own the league" do
    sign_in @user_without_leagues
    put league_path(@league), params: { league: league_params.merge!(name: 'Updated') }
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
    assert_template 'index'
  end

  test "#update updates a league" do
    sign_in @user_with_leagues

    put league_path(@league), params: { league: league_params.merge!(name: 'Updated') }

    @league.reload
    assert_equal 'Updated', @league.name
  end

  test "#update redirects to leagues#show" do
    sign_in @user_with_leagues

    put league_path(@league), params: { league: league_params }
    assert_redirected_to league_path(League.last)
  end

  test "#update renders edit with errors if creation fails" do
    sign_in @user_with_leagues

    put league_path(@league), params: { league: league_params.merge!(name: nil) }
    assert_template 'edit'
    assert_select "div.flash>div.error"
  end

  test "#destroy redirects to login page if user is not logged in" do
    delete league_path(@league)
    assert_redirected_to new_user_session_path
  end

  test "#destroy redirects index page with error if the user does not own the league" do
    sign_in @user_without_leagues
    delete league_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.error"
    assert_template 'index'
  end

  test "#destroy destroys a league" do
    sign_in @user_with_leagues
    delete league_path(@league)
    assert_raises 'ActiveRecord::RecordNotFound' do
      @league.reload
    end
  end

  test "#destroy redirects to leagues#index with a notice" do
    sign_in @user_with_leagues

    delete league_path(@league)
    assert_redirected_to leagues_path

    follow_redirect!
    assert_select "div.flash>div.notice"
    assert_template 'index'
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

end