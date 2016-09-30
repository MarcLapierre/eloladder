class CreateRankingHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :ranking_histories do |t|
      t.references :league, foreign_key: true, null: false, index: true
      t.references :player, foreign_key: true, null: false, index: true
      t.integer :opponent_id, null: false
      t.integer :ranking_before, null: false
      t.integer :ranking_after, null: false
      t.integer :opponent_ranking_before, null: false
      t.integer :opponent_ranking_after, null: false
      t.boolean :won, null: false
      t.integer :score, null: false
      t.integer :opponent_score, null: false
      t.timestamps
    end
  end
end
