class LeaguesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_league, only: [:show, :edit, :update, :add_match_result, :enter_match_result, :invite]
  before_action :load_player, only: [:show, :edit, :update, :add_match_result, :enter_match_result]
  before_action :ensure_owner, only: [:edit, :update, :invite]
  before_action :ensure_at_least_two_players, only: [:enter_match_result]

  def new
    @league = League.new
  end

  def create
    permitted = permitted_params.merge(user: current_user)
    op = League::Create.new(permitted.to_h.symbolize_keys)
    @league = op.call

    if op.succeeded?
      flash[:notice] = "League created successfully"
      redirect_to @league
    else
      render 'new'
    end
  rescue StandardError => e
    Rails.logger.error("LeaguesController#create #{e.inspect}")
    flash[:error] = "There was a creating the league."
    render "new"
  end

  def index
    @leagues = current_user.leagues
    @unclaimed_invitations = current_user.invitations.pending
  end

  def show
    @players_without_games_played = @league.players.where('rating_histories_count = 0').order(created_at: :desc)
    @players_with_games_played = @league.players.where('rating_histories_count > 0').order(rating: :desc)
  end

  def update
    permitted = permitted_params.merge(league: @league)
    op = League::Update.new(permitted.to_h.symbolize_keys)
    @league = op.call

    if op.succeeded?
      flash[:notice] = "League updated successfully"
      redirect_to @league
    else
      render "edit"
    end
  rescue StandardError => e
    Rails.logger.error("LeaguesController#update #{e.inspect}")
    flash[:error] = "There was a updating the league."
    render "edit"
  end

  def edit
  end

  def enter_match_result
    @opponents = @league.players - [@player]
    @score_range = (0..2) #TODO @league.score_range
  end

  def add_match_result
    opponent = @league.players.find_by(id: params[:opponent_id])
    op = Match::Record.new(
      league: @league,
      player: @player,
      opponent: opponent,
      player_score: params[:player_score].to_i,
      opponent_score: params[:opponent_score].to_i
    )
    op.call
    if op.succeeded?
      flash[:notice] = "Your match was recorded successfully!"
    else
      flash[:error] = "There was a problem recording your match."
    end
  rescue StandardError => e
    Rails.logger.error("LeaguesController#add_match_result #{e.inspect}")
    flash[:error] = "There was a problem recording your match."
  ensure
    redirect_to @league
  end

  def invite
    op = Invitation::Create.new(league: @league, email: params[:email])
    op.call
    if op.succeeded?
      flash[:notice] = "Invitation sent."
    else
      flash[:error] = "A pending invitation already exists for that user."
    end
  rescue StandardError => e
    Rails.logger.error("LeaguesController#invite #{e.inspect}")
    flash[:error] = "There was a problem sending the invitation."
  ensure
    redirect_to @league
  end

  private

  def load_league
    @league = current_user.leagues.find_by(id: params[:id])
    unless @league
      flash[:error] = "We couldn't find that league."
      redirect_to leagues_path
    end
  end

  def load_player
    @player = current_user.players.find_by(league: @league)
  end

  def ensure_owner
    unless @league.players.find_by(user: current_user).owner
      flash[:error] = "Nuh-uh. Can't do that."
      redirect_to leagues_path
    end
  end

  def ensure_at_least_two_players
    unless @league.players.count > 1
      flash[:error] = "You're the only player - why not invite some friends?"
      redirect_to @league
    end
  end

  def permitted_params
    params.require(:league).permit(["name", "description", "rules", "website_url", "logo_url"])
  end
end
