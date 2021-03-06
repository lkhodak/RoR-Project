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

ActiveRecord::Schema.define(version: 20140809194234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ctos", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "address"
    t.text     "contacts"
    t.text     "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "orders", force: true do |t|
    t.float    "price"
    t.datetime "requestDate"
    t.datetime "confirmationDate"
    t.string   "status"
    t.datetime "plannedDate"
    t.integer  "user_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "carNumber"
    t.string   "uniqueCode"
  end

  add_index "orders", ["service_id"], name: "index_orders_on_service_id", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "reviews", force: true do |t|
    t.string   "reviewText"
    t.integer  "mark"
    t.integer  "user_id"
    t.integer  "service_id"
    t.integer  "cto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["cto_id"], name: "index_reviews_on_cto_id", using: :btree
  add_index "reviews", ["service_id"], name: "index_reviews_on_service_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "schedules", force: true do |t|
    t.date     "date"
    t.datetime "start"
    t.datetime "end"
    t.integer  "cto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.float    "price"
    t.integer  "cto_id"
  end

  add_index "services", ["cto_id"], name: "index_services_on_cto_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "role"
    t.integer  "cto_id"
  end

  add_index "users", ["cto_id"], name: "index_users_on_cto_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
