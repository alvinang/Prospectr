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

ActiveRecord::Schema.define(version: 20130605070200) do

  create_table "twitter_user_searches", force: true do |t|
    t.string   "query"
    t.text     "result",     limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_user_searches", ["query"], name: "index_twitter_user_searches_on_query", unique: true, using: :btree

  create_table "twitter_user_timelines", force: true do |t|
    t.string   "query"
    t.text     "result",     limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_user_timelines", ["query"], name: "index_twitter_user_timelines_on_query", unique: true, using: :btree

end
