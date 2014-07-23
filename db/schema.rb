# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140721182138) do

  create_table "coordinates", force: true do |t|
    t.float   "time_stamp"
    t.float   "latitude"
    t.float   "longitude"
    t.integer "trip_id"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patterns", force: true do |t|
    t.string   "pattern_type"
    t.float    "raw_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score_id"
    t.float    "start_time"
    t.float    "end_time"
  end

  create_table "scores", force: true do |t|
    t.float    "scoreAverage"
    t.float    "scoreAccels"
    t.float    "scoreBreaks"
    t.float    "scoreLaneChanges"
    t.float    "scoreTurns"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trip_id"
  end

  create_table "trips", force: true do |t|
    t.string   "name"
    t.datetime "time_stamp"
    t.float    "distance"
    t.float    "duration"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.time     "time"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.integer  "group_id"
    t.boolean  "admin",                  default: false
    t.integer  "invitation_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["group_id"], name: "index_group_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
