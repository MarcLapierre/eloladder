class RemoveFieldsFromRatingHistory < ActiveRecord::Migration[5.0]
  def change
    remove_column :rating_histories, :won
    remove_column :rating_histories, :league_id
  end
end
