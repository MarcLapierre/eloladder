class AddRatingHistoryCountToPlayers < ActiveRecord::Migration[5.0]
  def change
    change_table :players do |t|
      t.integer :rating_histories_count, default: 0
    end

    reversible do |dir|
      dir.up { data }
    end
  end

  def data
    execute <<-SQL.squish
        UPDATE players
           SET rating_histories_count = (SELECT count(1)
                                           FROM rating_histories
                                           WHERE rating_histories.player_id = players.id)
    SQL
  end
end
