class AddMatchIdToRatingHistory < ActiveRecord::Migration[5.0]
  def change
    add_reference :rating_histories, :match, index: true

    matches = Match.all
    rhs = RatingHistory.all

    rhs.each_with_index do |rh, i|
      rh.update_attributes!(match: matches[(i / 2.0).floor])
    end

    change_column_null :rating_histories, :match_id, false
  end
end
