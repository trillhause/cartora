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

ActiveRecord::Schema.define(version: 20170117052333) do

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.integer  "host_id",    null: false
    t.integer  "start_time", null: false
    t.integer  "end_time",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_events_on_host_id", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal  "lat",        precision: 10, scale: 6, null: false
    t.decimal  "lng",        precision: 10, scale: 6, null: false
    t.string   "area_type",                           null: false
    t.integer  "area_id",                             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["area_type", "area_id"], name: "index_locations_on_area_type_and_area_id", using: :btree
  end

  create_table "participations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id",                    null: false
    t.integer  "event_id",                   null: false
    t.boolean  "attending",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id", "event_id"], name: "index_participations_on_user_id_and_event_id", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token",             default: ""
    t.string   "first_name"
    t.string   "last_name"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
