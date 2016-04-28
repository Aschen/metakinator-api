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

ActiveRecord::Schema.define(version: 20160428150358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "answer",      default: 3
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "entity_id"
  end

  add_index "answers", ["entity_id"], name: "index_answers_on_entity_id", using: :btree

  create_table "entities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "klass"
  end

  add_index "entities", ["klass"], name: "index_entities_on_klass", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "nominal"
    t.string   "entity_class"
  end

  add_index "questions", ["entity_class"], name: "index_questions_on_entity_class", using: :btree

end
