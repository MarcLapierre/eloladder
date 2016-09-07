class CreateLeagues < ActiveRecord::Migration[5.0]
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :rules, null: false
      t.string :website_url
      t.string :logo_url
      t.references :user, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
