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

ActiveRecord::Schema.define(version: 20150820141459) do

  create_table "bnfs", force: true do |t|
    t.integer "component_id"
    t.string  "component_type"
    t.text    "bnf_json"
  end

  add_index "bnfs", ["component_id", "component_type"], name: "index_bnfs_on_component_id_and_component_type"

  create_table "competence_coverages", id: false, force: true do |t|
    t.integer  "ka_result_id"
    t.integer  "competence_id"
    t.float    "mark",          default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competence_coverages", ["competence_id"], name: "index_competence_coverages_on_competence_id"
  add_index "competence_coverages", ["ka_result_id"], name: "index_competence_coverages_on_ka_result_id"

  create_table "competences", force: true do |t|
    t.string   "code",        default: "", null: false
    t.string   "description", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constructs", force: true do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "etalonframes", force: true do |t|
    t.string   "name"
    t.text     "dictionary"
    t.text     "studentcode"
    t.text     "framecode"
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mistakes"
    t.text     "kbmistakes"
  end

  create_table "etalons", force: true do |t|
    t.string   "name"
    t.text     "etalonjson"
    t.text     "nodejson"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extension_databases", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filling_utz_answers", force: true do |t|
    t.string   "text"
    t.integer  "filling_utz_interval_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "filling_utz_answers", ["filling_utz_interval_id"], name: "index_filling_utz_answers_on_filling_utz_interval_id"

  create_table "filling_utz_intervals", force: true do |t|
    t.integer  "start"
    t.integer  "end"
    t.string   "answer"
    t.integer  "filling_utz_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "filling_utzs", force: true do |t|
    t.string   "name"
    t.text     "hint"
    t.integer  "level"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "text"
    t.integer  "ka_topic_id"
  end

  add_index "filling_utzs", ["ka_topic_id"], name: "index_filling_utzs_on_ka_topic_id"

  create_table "frame_solvers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "framedbs", force: true do |t|
    t.text     "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frameobjectmistakes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frameobjects", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frames", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "framesmistakes", force: true do |t|
    t.text     "mistakes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "images_sort_utz_pictures", force: true do |t|
    t.text     "src"
    t.integer  "ordering"
    t.integer  "images_sort_utz_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "images_sort_utz_pictures", ["images_sort_utz_id"], name: "index_images_sort_utz_pictures_on_images_sort_utz_id"

  create_table "images_sort_utzs", force: true do |t|
    t.text     "goal"
    t.text     "theme"
    t.string   "hint"
    t.integer  "level"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "ka_topic_id"
  end

  add_index "images_sort_utzs", ["ka_topic_id"], name: "index_images_sort_utzs_on_ka_topic_id"

  create_table "ka_answer_logs", force: true do |t|
    t.integer  "ka_result_id"
    t.integer  "ka_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ka_answers", force: true do |t|
    t.text     "text",           default: "", null: false
    t.integer  "correct",        default: 0,  null: false
    t.integer  "ka_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ka_answers", ["ka_question_id"], name: "index_ka_answers_on_ka_question_id"

  create_table "ka_questions", force: true do |t|
    t.text     "text",        default: "", null: false
    t.integer  "difficulty",  default: 0,  null: false
    t.integer  "ka_topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "disable",     default: 0,  null: false
  end

  add_index "ka_questions", ["ka_topic_id"], name: "index_ka_questions_on_ka_topic_id"

  create_table "ka_questions_variants", id: false, force: true do |t|
    t.integer  "ka_variant_id"
    t.integer  "ka_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ka_questions_variants", ["ka_variant_id", "ka_question_id"], name: "ka_q_ka_v", unique: true

  create_table "ka_results", force: true do |t|
    t.integer  "ka_variant_id"
    t.integer  "ka_test_id"
    t.integer  "user_id"
    t.integer  "assessment",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ka_results", ["ka_test_id"], name: "index_ka_results_on_ka_test_id"

  create_table "ka_tests", force: true do |t|
    t.text     "text",                        null: false
    t.integer  "on",              default: 0, null: false
    t.integer  "variants_count",  default: 0, null: false
    t.integer  "questions_count", default: 0, null: false
    t.integer  "minutes",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ka_topics", force: true do |t|
    t.string   "text",       default: "", null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ka_topics", ["parent_id"], name: "index_ka_topics_on_parent_id"

  create_table "ka_variants", force: true do |t|
    t.integer  "ka_test_id"
    t.integer  "number",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ka_variants", ["ka_test_id", "number"], name: "index_ka_variants_on_ka_test_id_and_number"

  create_table "logs", force: true do |t|
    t.text    "result"
    t.text    "data"
    t.integer "component_id"
    t.string  "component_type"
  end

  add_index "logs", ["component_id", "component_type"], name: "index_logs_on_component_id_and_component_type"

  create_table "matching_utz_answers", force: true do |t|
    t.text     "text"
    t.integer  "matching_utz_question_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "matching_utz_questions", force: true do |t|
    t.text     "text"
    t.integer  "matching_utz_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "matching_utzs", force: true do |t|
    t.string   "name"
    t.text     "hint"
    t.integer  "level"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "ka_topic_id"
  end

  add_index "matching_utzs", ["ka_topic_id"], name: "index_matching_utzs_on_ka_topic_id"

  create_table "methodical_materials", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.text     "theoretical_part"
    t.text     "practical_part"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalities", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "personality_trait_id"
    t.float    "begin_at",             default: 0.0
    t.float    "end_at",               default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personalities_students", id: false, force: true do |t|
    t.integer "personality_id", null: false
    t.integer "student_id",     null: false
  end

  create_table "personality_test_answer_pictures", force: true do |t|
    t.string   "image_uid"
    t.integer  "personality_test_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_answer_weights", force: true do |t|
    t.float    "value"
    t.integer  "personality_test_answer_id"
    t.integer  "personality_trait_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "personality_test_answer_weights", ["personality_trait_id"], name: "index_personality_test_answer_weights_on_personality_trait_id"

  create_table "personality_test_answers", force: true do |t|
    t.text     "value"
    t.integer  "personality_test_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_question_pictures", force: true do |t|
    t.string   "image_uid"
    t.integer  "personality_test_question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_question_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_test_questions", force: true do |t|
    t.text     "value"
    t.integer  "personality_test_question_type_id"
    t.integer  "personality_test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordering"
  end

  add_index "personality_test_questions", ["personality_test_id"], name: "index_personality_test_questions_on_personality_test_id"

  create_table "personality_test_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_tests", force: true do |t|
    t.string   "name"
    t.integer  "personality_test_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personality_tests_students", id: false, force: true do |t|
    t.integer "personality_test_id", null: false
    t.integer "student_id",          null: false
  end

  create_table "personality_trait_intervals", force: true do |t|
    t.float    "begin_at"
    t.float    "end_at"
    t.integer  "personality_id"
    t.integer  "personality_trait_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "personality_trait_intervals", ["personality_id"], name: "index_personality_trait_intervals_on_personality_id"
  add_index "personality_trait_intervals", ["personality_trait_id"], name: "index_personality_trait_intervals_on_personality_trait_id"

  create_table "personality_traits", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planner_events", force: true do |t|
    t.integer  "user_id"
    t.integer  "type_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planning_sessions", force: true do |t|
    t.integer  "user_id"
    t.integer  "closed",     default: 0
    t.string   "state"
    t.string   "plan"
    t.string   "procedure"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planning_tasks", force: true do |t|
    t.integer  "planning_session_id"
    t.integer  "closed",              default: 0
    t.string   "executor"
    t.string   "result"
    t.string   "action"
    t.string   "description"
    t.string   "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_areas", id: false, force: true do |t|
    t.integer  "ka_result_id"
    t.integer  "ka_topic_id"
    t.float    "mark",         default: 0.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problem_areas", ["ka_result_id"], name: "index_problem_areas_on_ka_result_id"
  add_index "problem_areas", ["ka_topic_id"], name: "index_problem_areas_on_ka_topic_id"

  create_table "results", force: true do |t|
    t.integer  "student_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "results_mask"
  end

  add_index "results", ["student_id"], name: "index_results_on_student_id"
  add_index "results", ["task_id"], name: "index_results_on_task_id"

  create_table "s_answers", force: true do |t|
    t.integer "task_id"
    t.text    "answer"
  end

  add_index "s_answers", ["task_id"], name: "index_s_answers_on_task_id"

  create_table "s_results", force: true do |t|
    t.integer "result_id"
    t.integer "mark"
    t.text    "answer"
  end

  add_index "s_results", ["result_id"], name: "index_s_results_on_result_id"

  create_table "schedules", force: true do |t|
    t.integer  "duration"
    t.string   "data",       default: "{}", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "semanticnetworks", force: true do |t|
    t.integer  "etalon_id"
    t.integer  "student_id"
    t.text     "json"
    t.text     "mistakes",   default: " Вы еще не прошли тест :) "
    t.boolean  "iscomplite", default: false
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "semanticnetworks", ["etalon_id"], name: "index_semanticnetworks_on_etalon_id"
  add_index "semanticnetworks", ["student_id"], name: "index_semanticnetworks_on_student_id"

  create_table "studentframes", force: true do |t|
    t.integer  "etalonframe_id"
    t.integer  "student_id"
    t.text     "studentcode"
    t.integer  "result"
    t.boolean  "isfinish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mistakes"
    t.text     "studentmistakes"
    t.text     "kbstudentmistakes"
  end

  add_index "studentframes", ["etalonframe_id"], name: "index_studentframes_on_etalonframe_id"
  add_index "studentframes", ["student_id"], name: "index_studentframes_on_student_id"

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

  create_table "test_utz_answers", force: true do |t|
    t.text     "text"
    t.boolean  "is_correct"
    t.integer  "test_utz_question_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "test_utz_answers", ["test_utz_question_id"], name: "index_test_utz_answers_on_test_utz_question_id"

  create_table "test_utz_questions", force: true do |t|
    t.text     "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "ka_topic_id"
  end

  add_index "test_utz_questions", ["ka_topic_id"], name: "index_test_utz_questions_on_ka_topic_id"

  create_table "text_correction_utzs", force: true do |t|
    t.string   "name"
    t.text     "text_with_errors"
    t.text     "text_without_errors"
    t.integer  "errors_count"
    t.string   "hint"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "ka_topic_id"
  end

  add_index "text_correction_utzs", ["ka_topic_id"], name: "index_text_correction_utzs_on_ka_topic_id"

  create_table "tokenlines", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_competences", id: false, force: true do |t|
    t.integer  "ka_topic_id"
    t.integer  "competence_id"
    t.integer  "weight",        default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_competences", ["competence_id"], name: "index_topic_competences_on_competence_id"
  add_index "topic_competences", ["ka_topic_id"], name: "index_topic_competences_on_ka_topic_id"

  create_table "topic_constructs", id: false, force: true do |t|
    t.integer  "ka_topic_id"
    t.integer  "construct_id"
    t.integer  "mark",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_constructs", ["construct_id"], name: "index_topic_constructs_on_construct_id"
  add_index "topic_constructs", ["ka_topic_id"], name: "index_topic_constructs_on_ka_topic_id"

  create_table "trees", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
