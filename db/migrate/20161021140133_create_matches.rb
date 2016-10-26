class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :league, foreign_key: true, null: false, index: true
      t.references :player, foreign_key: true, null: false, index: true
      t.integer :opponent_id, null: false
      t.integer :player_score, null: false
      t.integer :opponent_score, null: false
      t.timestamps
    end
    add_foreign_key :matches, :players, column: :opponent_id, primary_key: "id"
  end
end
