class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.string :token, null: false, index: true, unique: true
      t.references :league, foreign_key: true, null: false, index: true
      t.references :user, foreign_key: true, index: true
      t.string :email, null: false, index: true
      t.string :state, null: false, index: true
      t.datetime :accepted_at
      t.datetime :declined_at
      t.timestamps
    end
  end
end
