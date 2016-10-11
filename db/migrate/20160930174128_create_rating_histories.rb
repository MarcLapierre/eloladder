class CreateRatingHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :rating_histories do |t|
      t.references :league, foreign_key: true, null: false, index: true
      t.references :player, foreign_key: true, null: false, index: true
      t.integer :opponent_id, null: false
      t.integer :rating_before, null: false
      t.integer :rating_after, null: false
      t.integer :opponent_rating_before, null: false
      t.integer :opponent_rating_after, null: false
      t.boolean :won, null: false
      t.timestamps
    end
  end
end
