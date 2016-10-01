class AddGamesPlayedToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :games_played, :integer, null: false, default: 0
  end
end
