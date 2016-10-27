class AddRatingHistoryOutcome < ActiveRecord::Migration[5.0]
  def change
    add_column :rating_histories, :outcome, :string

    RatingHistory.find_each do |rh|
      rh.update_attributes!(outcome: rh.won ? "won" : "lost")
    end
  end
end
