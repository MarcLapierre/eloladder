class PlayersController < ApplicationController
  include ChartHelper

  before_action :authenticate_user!
  before_action :load_player
  before_action :load_league
  before_action :load_rating_histories, only: [:show]

  def show
  end

  private

  def load_player
    @player = Player.find(params[:id])
  end

  def load_league
    @league = @player.league
    unless @league && current_user.leagues.include?(@league)
      flash[:error] = "We couldn't find that league."
      redirect_to leagues_path
    end
  end

  def load_rating_histories
    @rating_histories ||= @player.rating_histories.order(:created_at)
  end
end
