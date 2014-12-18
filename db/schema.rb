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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20141103214052) do
=======
ActiveRecord::Schema.define(version: 20141218100510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "call_histories", force: true do |t|
    t.string   "json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
>>>>>>> newtripviewer

  create_table "coordinates", force: true do |t|
    t.datetime "time_stamp"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "trip_id"
    t.integer  "gps_id"
    t.float    "speed"
  end

  add_index "coordinates", ["trip_id"], name: "index_coordinates_on_trip_id"

  create_table "device_logs", force: true do |t|
    t.integer  "udid",       limit: 8
    t.string   "ip_address"
    t.float    "power"
    t.string   "nickname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_logs", force: true do |t|
    t.integer  "udid"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "mappable_events", force: true do |t|
    t.datetime "time_stamp"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "score"
    t.integer  "pattern_type"
    t.integer  "trip_id"
    t.float    "speed"
  end

  add_index "mappable_events", ["trip_id"], name: "index_mappable_events_on_trip_id", using: :btree

  create_table "patterns", force: true do |t|
    t.string   "pattern_type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "raw_score"
    t.integer  "score_id"
    t.integer  "gps_index_start"
    t.integer  "gps_index_end"
  end

  add_index "patterns", ["score_id"], name: "index_patterns_on_score_id"

  create_table "scores", force: true do |t|
    t.float   "scoreAverage"
    t.float   "scoreAccels"
    t.float   "scoreBreaks"
    t.float   "scoreLaneChanges"
    t.float   "scoreTurns"
    t.integer "trip_id"
  end

  add_index "scores", ["trip_id"], name: "index_scores_on_trip_id"

  create_table "trips", force: true do |t|
    t.string   "name"
    t.datetime "time_stamp"
    t.float    "distance"
    t.float    "duration"
    t.integer  "score"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "scoreAccels"
    t.float    "scoreBreaks"
    t.float    "scoreLaneChanges"
    t.float    "scoreTurns"
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id"

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
    t.boolean  "outstanding_invitation", default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
