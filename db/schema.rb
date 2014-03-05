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

ActiveRecord::Schema.define(version: 20140305134613) do

  create_table "bnf_rules", force: true do |t|
    t.text     "left"
    t.text     "right"
    t.integer  "bnf_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bnf_rules", ["bnf_id"], name: "index_bnf_rules_on_bnf_id"

  create_table "bnfs", force: true do |t|
    t.integer  "component_id"
    t.string   "component_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bnfs", ["component_id", "component_type"], name: "index_bnfs_on_component_id_and_component_type"

  create_table "tasks", force: true do |t|
    t.integer  "variant"
    t.text     "sentence1"
    t.text     "sentence2"
    t.text     "sentence3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["variant"], name: "index_tasks_on_variant", unique: true

  create_table "v_answers", force: true do |t|
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "v_answers", ["task_id"], name: "index_v_answers_on_task_id"

end
