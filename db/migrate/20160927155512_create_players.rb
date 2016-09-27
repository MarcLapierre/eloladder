class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :league, foreign_key: true, null: false, index: true
      t.references :user, foreign_key: true, null: false, index: true
      t.integer :rating, null: false
      t.boolean :pro, null: false, default: false
      t.timestamps
    end
  end
end
