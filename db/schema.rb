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

ActiveRecord::Schema.define(version: 20150902074453) do

  create_table "layout_patterns", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "web_pages", force: :cascade do |t|
    t.string   "url",                  null: false
    t.string   "capture_image_path"
    t.integer  "layout_pattern_id"
    t.text     "note"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "captured_at"
    t.text     "layout_data"
    t.string   "separated_image_path"
    t.integer  "matching_result"
  end

  add_index "web_pages", ["url"], name: "index_web_pages_on_url", unique: true

end
