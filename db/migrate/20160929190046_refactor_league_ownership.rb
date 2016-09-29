class RefactorLeagueOwnership < ActiveRecord::Migration[5.0]
  def change
    remove_column :leagues, :user_id
    add_column :players, :owner, :boolean, default: false
  end
end
