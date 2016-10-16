class PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_player
  before_action :load_league

  def show
    @rating_histories = @player.rating_histories.order(created_at: :desc)
    @rating_histories_chart_data = rating_histories_chart_data
    @rating_histories_chart_options = rating_histories_chart_options
    @position = Player::Position.call(@player)
    @days_since_played = Player::DaysSincePlayed.call(@player)
    @streak = Player::Streak.call(@player)
  end

  private

  def load_league
    @league = @player.league
    unless @league && current_user.leagues.include?(@league)
      flash[:error] = "We couldn't find that league."
      redirect_to leagues_path
    end
  end

  def load_player
    @player = Player.find(params[:id])
  end

  def rating_histories_chart_data
    {
      datasets: [{
        fill: false,
        borderColor: "#e5474b",
        data: get_rating_histories_chart_data
      }]
    }
  end

  def get_rating_histories_chart_data
    @player.rating_histories.map { |rating_history|
      {
        x: rating_history.created_at.to_i * 1000,
        y: rating_history.rating_after
      }
    }
  end

  def rating_histories_chart_options
    {
      width: 800,
      height: 480,
      scales: {
        xAxes: [{
          type: 'time',
          time: {
            unit: 'day'
          }
        }]
      }
    }
  end
end