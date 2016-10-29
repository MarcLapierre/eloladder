module PlayersHelper
  def rating_histories_chart_data
    @rating_histories_chart_data ||= begin
      return unless @rating_histories.any?
      rating_dataset = origin_point + @rating_histories.map { |rating_history|
        {
          x: rating_history.created_at.to_i * 1000,
          y: rating_history.rating_after
        }
      }
      line_chart_data(rating_dataset)
    end
  end

  def rating_histories_chart_options
    @rating_histories_chart_options ||= begin
      return unless @rating_histories.any?
      time_span = @rating_histories.last.created_at - @rating_histories.first.created_at
      line_chart_time_options(time_span)
    end
  end

  def origin_point
    [{
      x: @player.created_at,
      y: Elo.config.default_rating
    }]
  end

  def position_in_league
    @position_in_league ||= Player::Position.call(@player)
  end

  def days_since_played
    @days_since_played ||= Player::DaysSincePlayed.call(@player)
  end

  def winning_streak
    @winning_streak ||= Player::Streak.call(@player)
  end
end
