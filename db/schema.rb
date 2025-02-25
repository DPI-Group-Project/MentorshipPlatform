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

ActiveRecord::Schema[7.2].define(version: 2025_01_24_012208) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "role", ["mentor", "mentee"]
  create_enum "status", ["active", "inactive", "archived"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cohort_members", primary_key: "email", id: :string, force: :cascade do |t|
    t.bigint "cohort_id", null: false
    t.enum "role", enum_type: "role"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_cohort_members_on_cohort_id"
    t.index ["email"], name: "index_cohort_members_on_email", unique: true
  end

  create_table "cohorts", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.string "cohort_name"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "required_meetings"
    t.datetime "shortlist_start_time"
    t.datetime "shortlist_end_time"
    t.bigint "creator_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_cohorts_on_contact_id"
    t.index ["creator_id"], name: "index_cohorts_on_creator_id"
    t.index ["program_id"], name: "index_cohorts_on_program_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "mentee_id", null: false
    t.bigint "cohort_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_matches_on_cohort_id"
    t.index ["mentee_id"], name: "index_matches_on_mentee_id"
    t.index ["mentor_id"], name: "index_matches_on_mentor_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.date "date"
    t.time "time"
    t.text "notes"
    t.string "location"
    t.string "location_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_meetings_on_match_id"
  end

  create_table "program_admins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_admin_id"
    t.boolean "super_user", default: false, null: false
    t.index ["program_id"], name: "index_program_admins_on_program_id"
    t.index ["user_id"], name: "index_program_admins_on_user_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_programs_on_contact_id"
  end

  create_table "short_lists", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "mentee_id", null: false
    t.bigint "cohort_id", null: false
    t.integer "ranking"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cohort_id"], name: "index_short_lists_on_cohort_id"
    t.index ["mentee_id"], name: "index_short_lists_on_mentee_id"
    t.index ["mentor_id", "mentee_id", "cohort_id"], name: "index_short_lists_on_mentor_mentee_cohort", unique: true
    t.index ["mentor_id"], name: "index_short_lists_on_mentor_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.integer "match_id"
    t.integer "responsive", default: 0, null: false
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "experience", default: 0, null: false
    t.text "responsive_reason"
    t.text "experience_reason"
    t.text "additional_note"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.enum "status", default: "active", enum_type: "status"
    t.text "inactive_reason"
    t.string "phone_number"
    t.text "bio"
    t.string "timezone"
    t.string "title"
    t.string "linkedin_link"
    t.text "skills_array", default: [], array: true
    t.jsonb "shortlist", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cohort_members", "cohorts"
  add_foreign_key "cohorts", "programs"
  add_foreign_key "cohorts", "users", column: "contact_id"
  add_foreign_key "cohorts", "users", column: "creator_id"
  add_foreign_key "matches", "cohorts"
  add_foreign_key "matches", "users", column: "mentee_id"
  add_foreign_key "matches", "users", column: "mentor_id"
  add_foreign_key "meetings", "matches"
  add_foreign_key "program_admins", "programs"
  add_foreign_key "program_admins", "users"
  add_foreign_key "program_admins", "users", column: "created_by_admin_id"
  add_foreign_key "programs", "users", column: "contact_id"
  add_foreign_key "short_lists", "cohorts"
  add_foreign_key "short_lists", "users", column: "mentee_id"
  add_foreign_key "short_lists", "users", column: "mentor_id"
end
