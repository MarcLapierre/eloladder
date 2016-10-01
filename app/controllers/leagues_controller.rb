class LeaguesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_league, only: [:show, :edit, :update, :add_match_result]
  before_action :ensure_owner, only: [:edit, :update]

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
      flash[:error] = @league.errors.full_messages
      render 'new'
    end
  rescue StandardError => e
    Rails.logger.error("LeaguesController#create #{e.inspect}")
    flash[:error] = "There was a creating the league."
    render "new"
  end

  def index
    @leagues = current_user.leagues
  end

  def show
  end

  def update
    permitted = permitted_params.merge(league: @league)
    op = League::Update.new(permitted.to_h.symbolize_keys)
    @league = op.call

    if op.succeeded?
      flash[:notice] = "League updated successfully"
      redirect_to @league
    else
      flash[:error] = @league.errors.full_messages
      render "edit"
    end
  rescue StandardError => e
    Rails.logger.error("LeaguesController#update #{e.inspect}")
    flash[:error] = "There was a updating the league."
    render "edit"
  end

  def edit
  end

  def add_match_result
    player = @league.players.find_by(user: current_user)
    opponent = @league.players.find_by(id: params[:opponent_id])
    op = Match::Record.new(
      league: @league,
      player: player,
      opponent: opponent,
      score: params[:score].to_i,
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
    flash[:error] = "There was a problem sending the invitation."
  ensure
    redirect_to @league
  end

  private

  def load_league
    @league = current_user.leagues.find_by_id(params[:id])
    unless @league
      flash[:error] = "We couldn't find that league."
      redirect_to leagues_path
    end
  end

  def ensure_owner
    unless @league.players.find_by(user: current_user).owner
      flash[:error] = "Nuh-uh. Can't do that."
      redirect_to leagues_path
    end
  end

  def permitted_params
    params.require(:league).permit(["name", "description", "rules", "website_url", "logo_url"])
  end
end
