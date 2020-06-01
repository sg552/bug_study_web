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

ActiveRecord::Schema.define(version: 20200601074059) do

  create_table "bugs", force: :cascade do |t|
    t.text    "wybug_id",             limit: 4294967295
    t.text    "wybug_title",          limit: 4294967295
    t.text    "wybug_corp",           limit: 4294967295
    t.text    "wybug_author",         limit: 4294967295
    t.string  "wybug_date",           limit: 255
    t.string  "wybug_open_date",      limit: 255
    t.string  "wybug_type",           limit: 255
    t.string  "wybug_level",          limit: 255
    t.string  "wybug_rank_0",         limit: 255
    t.text    "wybug_status",         limit: 4294967295
    t.text    "wybug_from",           limit: 4294967295
    t.text    "wybug_tags",           limit: 4294967295
    t.text    "wybug_detail",         limit: 4294967295
    t.text    "wybug_reply",          limit: 4294967295
    t.text    "replys",               limit: 4294967295
    t.string  "wybug_level_fromcorp", limit: 255
    t.integer "wybug_rank_fromcorp",  limit: 4
    t.integer "Ranks",                limit: 4
  end

  add_index "bugs", ["wybug_id"], name: "bugs_wybug_id", type: :fulltext

  create_table "comments", force: :cascade do |t|
    t.integer  "bug_id",     limit: 4
    t.integer  "user_id",    limit: 4
    t.text     "comment",    limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["bug_id"], name: "index_comments_on_bug_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "whitehats", force: :cascade do |t|
    t.string  "whitehat",  limit: 255
    t.integer "Ranks",     limit: 4
    t.integer "bug_count", limit: 4
    t.string  "join_date", limit: 255
  end

end
