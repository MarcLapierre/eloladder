class RemoveGamesPlayedFromPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :games_played
  end
end
