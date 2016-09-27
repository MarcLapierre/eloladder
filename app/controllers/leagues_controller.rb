class LeaguesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_league, only: [:show, :edit, :update, :destroy]

  def new
    @league = League.new
  end

  def create
    permitted = params.permit(["name", "description", "rules", "website_url", "logo_url"])
    @league = League.new(permitted.merge(user: current_user))
    if @league.valid?
      League::Create.call(@league)
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
    permitted = params.require(:league).permit(["name", "description", "rules", "website_url", "logo_url"])
    if @league.update(permitted)
      flash[:notice] = "League updated successfully"
      redirect_to @league
    else
      flash[:error] = @league.errors.full_messages
      render "edit"
    end
  end

  def edit
  end

  def destroy
    if @league.destroy
      flash[:notice] = "League deleted successfully"
      redirect_to leagues_path
    else
      flash[:error] = @league.errors.full_messages
      redirect_to @league
    end
  end

  private

  def load_league
    @league = current_user.leagues.find_by_id(params[:id])
    unless @league
      flash[:error] = "We couldn't find that league."
      redirect_to leagues_path
    end
  end
end
