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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20170621221706) do
=======
ActiveRecord::Schema.define(version: 20170621002252) do
>>>>>>> turn_based_logic

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "number_of_moves"
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.integer  "game_status"
<<<<<<< HEAD
    t.integer  "piece_capturable_by_en_passant"
=======
    t.integer  "turn"
>>>>>>> turn_based_logic
    t.index ["black_player_id"], name: "index_games_on_black_player_id", using: :btree
    t.index ["name"], name: "index_games_on_name", using: :btree
    t.index ["white_player_id"], name: "index_games_on_white_player_id", using: :btree
  end

  create_table "pieces", force: :cascade do |t|
    t.string   "type"
    t.string   "color"
    t.boolean  "is_on_board?",      default: true
    t.integer  "column_coordinate"
    t.integer  "row_coordinate"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "game_id"
    t.integer  "user_id"
    t.string   "image"
    t.index ["game_id"], name: "index_pieces_on_game_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "game_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "image"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
