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

ActiveRecord::Schema.define(version: 20141231050512) do

  create_table "contents", primary_key: "contentsid", force: :cascade do |t|
    t.string   "contentstitle"
    t.string   "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taglinks", force: :cascade do |t|
    t.integer "contentsid"
    t.integer "tagid"
  end

  create_table "tags", primary_key: "tagid", force: :cascade do |t|
    t.string   "tagname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
