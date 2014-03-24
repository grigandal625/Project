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

ActiveRecord::Schema.define(version: 20140324091445) do

  create_table "bnf_rules", force: true do |t|
    t.text    "left"
    t.text    "right"
    t.integer "bnf_id"
  end

  add_index "bnf_rules", ["bnf_id"], name: "index_bnf_rules_on_bnf_id"

  create_table "bnfs", force: true do |t|
    t.integer "component_id"
    t.string  "component_type"
    t.text    "bnf_json"
  end

  add_index "bnfs", ["component_id", "component_type"], name: "index_bnfs_on_component_id_and_component_type"

  create_table "g_answers", force: true do |t|
    t.text    "answer"
    t.integer "task_id"
  end

  add_index "g_answers", ["task_id"], name: "index_g_answers_on_task_id"

  create_table "g_results", force: true do |t|
    t.integer "result_id"
    t.text    "answer"
    t.integer "mark"
  end

  add_index "g_results", ["result_id"], name: "index_g_results_on_result_id"

  create_table "groups", force: true do |t|
    t.text "number"
  end

  create_table "logs", force: true do |t|
    t.text    "mistakes"
    t.text    "data"
    t.integer "component_id"
    t.string  "component_type"
  end

  add_index "logs", ["component_id", "component_type"], name: "index_logs_on_component_id_and_component_type"

  create_table "results", force: true do |t|
    t.integer  "student_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["student_id"], name: "index_results_on_student_id"
  add_index "results", ["task_id"], name: "index_results_on_task_id"

  create_table "s_answers", force: true do |t|
    t.integer  "task_id"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "s_answers", ["task_id"], name: "index_s_answers_on_task_id"

  create_table "s_results", force: true do |t|
    t.integer "result_id"
    t.integer "mark"
    t.text    "answer"
  end

  add_index "s_results", ["result_id"], name: "index_s_results_on_result_id"

  create_table "students", force: true do |t|
    t.text    "fio"
    t.integer "group_id"
  end

  add_index "students", ["group_id"], name: "index_students_on_group_id"

  create_table "tasks", force: true do |t|
    t.text "sentence1"
    t.text "sentence2"
    t.text "sentence3"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "pass"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
  end

  add_index "users", ["student_id"], name: "index_users_on_student_id"

  create_table "v_answers", force: true do |t|
    t.integer "task_id"
  end

  add_index "v_answers", ["task_id"], name: "index_v_answers_on_task_id"

  create_table "v_results", force: true do |t|
    t.integer "result_id"
    t.integer "mark"
  end

  add_index "v_results", ["result_id"], name: "index_v_results_on_result_id"

end
