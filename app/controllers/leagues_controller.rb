class LeaguesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_league, only: [:show, :edit, :update]
  before_action :ensure_owner, only: [:edit, :update]

  def new
    @league = League.new
  end

  def create
    permitted = params.require(:league).permit(permitted_attributes).merge(user: current_user)
    op = League::Create.new(permitted.to_h.symbolize_keys)
    @league = op.call

    if op.succeeded?
      flash[:notice] = "League created successfully"
      redirect_to @league
    else
      flash[:error] = @league.errors.full_messages
      render 'new'
    end
  end

  def index
    @leagues = current_user.leagues
  end

  def show
  end

  def update
    permitted = params.require(:league).permit(permitted_attributes).merge(league: @league)
    op = League::Update.new(permitted.to_h.symbolize_keys)
    @league = op.call

    if op.succeeded?
      flash[:notice] = "League updated successfully"
      redirect_to @league
    else
      flash[:error] = @league.errors.full_messages
      render "edit"
    end
  end

  def edit
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

  def permitted_attributes
    ["name", "description", "rules", "website_url", "logo_url"]
  end
end
