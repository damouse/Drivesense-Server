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

ActiveRecord::Schema.define(version: 20140821202528) do

  create_table "coordinates", force: true do |t|
    t.datetime "time_stamp"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "trip_id"
    t.integer  "gps_id"
    t.float    "speed"
  end

  create_table "group_admins", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_invites", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_memberships", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patterns", force: true do |t|
    t.string   "pattern_type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "raw_score"
    t.integer  "score_id"
    t.integer  "gps_index_start"
    t.integer  "gps_index_end"
  end

  create_table "scores", force: true do |t|
    t.float   "scoreAverage"
    t.float   "scoreAccels"
    t.float   "scoreBreaks"
    t.float   "scoreLaneChanges"
    t.float   "scoreTurns"
    t.integer "trip_id"
  end

  create_table "trips", force: true do |t|
    t.string   "name"
    t.datetime "time_stamp"
    t.float    "distance"
    t.float    "duration"
    t.integer  "score"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.integer  "invited_id"
    t.integer  "admins_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
