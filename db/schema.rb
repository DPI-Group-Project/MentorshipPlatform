# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_19_223743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cohorts", force: :cascade do |t|
    t.bigint "program", null: false
    t.string "cohort_name"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "creator", null: false
    t.bigint "contact", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact"], name: "index_cohorts_on_contact"
    t.index ["creator"], name: "index_cohorts_on_creator"
    t.index ["program"], name: "index_cohorts_on_program"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "mentor_id"
    t.bigint "mentee_id"
    t.bigint "cohort_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_matches_on_cohort_id"
    t.index ["mentee_id"], name: "index_matches_on_mentee_id"
    t.index ["mentor_id"], name: "index_matches_on_mentor_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_organizations_on_program_id"
    t.index ["user_id"], name: "index_organizations_on_user_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "creator", null: false
    t.bigint "contact", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "required_meetings"
    t.index ["contact"], name: "index_programs_on_contact"
    t.index ["creator"], name: "index_programs_on_creator"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.string "responsive"
    t.text "body"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_reviews_on_match_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "role"
    t.string "status"
    t.text "inactive_reason"
    t.string "phone_number"
    t.text "bio"
    t.string "timezone"
    t.string "title"
    t.string "linkedin_link"
    t.string "profile_pic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "skills", default: [], array: true
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cohorts", "programs", column: "program"
  add_foreign_key "cohorts", "users", column: "contact"
  add_foreign_key "cohorts", "users", column: "creator"
  add_foreign_key "matches", "cohorts"
  add_foreign_key "matches", "users", column: "mentee_id"
  add_foreign_key "matches", "users", column: "mentor_id"
  add_foreign_key "organizations", "programs"
  add_foreign_key "organizations", "users"
  add_foreign_key "programs", "users", column: "contact"
  add_foreign_key "programs", "users", column: "creator"
  add_foreign_key "reviews", "matches"
end
