module ChartHelper
  BORDER_COLOR = "#e5474b".freeze
  DEFAULT_WIDTH = 800
  DEFAULT_HEIGHT = 480

  def line_chart_data(data)
    {
      datasets: [{
        fill: false,
        borderColor: BORDER_COLOR,
        #lineTension: 0,
        data: data
      }]
    }
  end

  def line_chart_time_options(time_span)
    {
      width: DEFAULT_WIDTH,
      height: DEFAULT_HEIGHT,
      scales: {
        xAxes: [{
          type: 'time',
          time: {
            unit: determine_time_chart_unit(time_span),
            tooltipFormat: "MMM Do, YYYY",
            displayFormats: {
              day: "MMM Do, YYYY",
              month: "MMM, YYYY",
              quarter: "MMM, YYYY",
              year: "YYYY"
            }
          },
        }]
      }
    }
  end

  private

  def determine_time_chart_unit(time_span)
    return 'day' if time_span < 30.days
    return 'month' if time_span < 1.year
    return 'quarter' if time_span < 3.years
    return 'year'
  end
end
