# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161027032211) do

  create_table "invitations", force: :cascade do |t|
    t.string   "token",       null: false
    t.integer  "league_id",   null: false
    t.integer  "user_id"
    t.string   "email",       null: false
    t.string   "state",       null: false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["email"], name: "index_invitations_on_email"
    t.index ["league_id"], name: "index_invitations_on_league_id"
    t.index ["state"], name: "index_invitations_on_state"
    t.index ["token"], name: "index_invitations_on_token"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description", null: false
    t.string   "rules",       null: false
    t.string   "website_url"
    t.string   "logo_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer  "league_id",      null: false
    t.integer  "player_id",      null: false
    t.integer  "opponent_id",    null: false
    t.integer  "player_score",   null: false
    t.integer  "opponent_score", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["league_id"], name: "index_matches_on_league_id"
    t.index ["player_id"], name: "index_matches_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer  "league_id",                              null: false
    t.integer  "user_id",                                null: false
    t.integer  "rating",                                 null: false
    t.boolean  "pro",                    default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "owner",                  default: false
    t.integer  "rating_histories_count", default: 0
    t.index ["league_id"], name: "index_players_on_league_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rating_histories", force: :cascade do |t|
    t.integer  "player_id",              null: false
    t.integer  "opponent_id",            null: false
    t.integer  "rating_before",          null: false
    t.integer  "rating_after",           null: false
    t.integer  "opponent_rating_before", null: false
    t.integer  "opponent_rating_after",  null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "match_id",               null: false
    t.string   "outcome"
    t.index ["match_id"], name: "index_rating_histories_on_match_id"
    t.index ["player_id"], name: "index_rating_histories_on_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
