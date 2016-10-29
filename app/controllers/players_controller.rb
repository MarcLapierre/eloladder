class PlayersController < ApplicationController
  include ChartHelper

  before_action :authenticate_user!
  before_action :load_player
  before_action :load_league
  before_action :load_rating_histories, only: [:show]

  def show
    @rating_histories_chart_data = rating_histories_chart_data
    @rating_histories_chart_options = rating_histories_chart_options
    @position = Player::Position.call(@player)
    @days_since_played = Player::DaysSincePlayed.call(@player)
    @streak = Player::Streak.call(@player)
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

  def rating_histories_chart_data
    return unless @rating_histories.any?
    rating_dataset = origin_point + @rating_histories.map { |rating_history|
      {
        x: rating_history.created_at.to_i * 1000,
        y: rating_history.rating_after
      }
    }
    line_chart_data(rating_dataset)
  end

  def rating_histories_chart_options
    return unless @rating_histories.any?
    time_span = @rating_histories.last.created_at - @rating_histories.first.created_at
    line_chart_time_options(time_span)
  end

  def origin_point
    [{
      x: @player.created_at,
      y: Elo.config.default_rating
    }]
  end

  def load_rating_histories
    @rating_histories ||= @player.rating_histories.order(created_at: :desc)
  end
end
