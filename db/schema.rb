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

ActiveRecord::Schema.define(version: 20170901200320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_records", force: :cascade do |t|
    t.string "university"
    t.date "start"
    t.date "finish"
    t.string "degree"
    t.float "gpa"
    t.float "gpa_range", default: 4.0
    t.text "gpa_comment"
    t.integer "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "transcript_file_name"
    t.string "transcript_content_type"
    t.integer "transcript_file_size"
    t.datetime "transcript_updated_at"
    t.string "major"
    t.string "minor"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "label"
    t.string "permanent"
    t.integer "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_accounts", force: :cascade do |t|
    t.string "admin1_email"
    t.string "admin1_pwd"
    t.string "admin2_email"
    t.string "admin2_pwd"
    t.string "admin3_email"
    t.string "admin3_pwd"
    t.string "admin4_email"
    t.string "admin4_pwd"
    t.string "admin5_email"
    t.string "admin5_pwd"
    t.bigint "grant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grant_id"], name: "index_admin_accounts_on_grant_id"
  end

  create_table "applicants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.date "dob"
    t.string "citizenship"
    t.string "disability"
    t.string "gender"
    t.string "ethnicity"
    t.string "race"
    t.string "academic_level"
    t.text "lab_skills"
    t.text "cpu_skills"
    t.text "statement"
    t.datetime "submitted_at"
    t.datetime "completed_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.string "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "gpa_comment"
    t.string "found_us"
    t.boolean "acknowledged_dates", default: false
    t.string "military"
    t.string "mentor1"
    t.string "mentor2"
    t.index ["authentication_token"], name: "index_applicants_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_applicants_on_confirmation_token", unique: true
    t.index ["email"], name: "index_applicants_on_email", unique: true
    t.index ["reset_password_token"], name: "index_applicants_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_applicants_on_unlock_token", unique: true
  end

  create_table "awards", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.text "description"
    t.integer "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grant_settings", force: :cascade do |t|
    t.string "institute"
    t.string "department"
    t.string "department_postal_address"
    t.date "application_start"
    t.date "application_deadline"
    t.date "notification_date"
    t.date "program_start_date"
    t.date "program_end_date"
    t.date "checkback_date"
    t.string "mail_from"
    t.string "funded_by"
    t.string "main_url"
    t.string "department_url"
    t.string "program_url"
    t.bigint "grant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grant_id"], name: "index_grant_settings_on_grant_id"
  end

  create_table "grant_snippets", force: :cascade do |t|
    t.text "general_desc"
    t.text "highlights"
    t.text "eligibility"
    t.bigint "grant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grant_id"], name: "index_grant_snippets_on_grant_id"
  end

  create_table "grants", force: :cascade do |t|
    t.string "program_title"
    t.string "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "contact_email"
    t.string "contact_password"
  end

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text "message"
    t.string "username"
    t.integer "item"
    t.string "table"
    t.integer "month", limit: 2
    t.bigint "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item", "table", "month", "year"], name: "index_rails_admin_histories"
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "known_applicant_for"
    t.string "known_capacity"
    t.string "overall_promise"
    t.string "undergraduate_institution"
    t.text "body"
    t.string "token"
    t.datetime "token_created_at"
    t.datetime "request_sent_at"
    t.datetime "received_at"
    t.integer "applicant_id"
    t.integer "recommender_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["applicant_id"], name: "index_recommendations_on_applicant_id"
    t.index ["recommender_id"], name: "index_recommendations_on_recommender_id"
  end

  create_table "recommenders", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.string "department"
    t.string "organization"
    t.string "url"
    t.string "email"
    t.string "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rich_rich_files", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "rich_file_file_name"
    t.string "rich_file_content_type"
    t.integer "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string "owner_type"
    t.integer "owner_id"
    t.text "uri_cache"
    t.string "simplified_type", default: "file"
    t.string "rich_file_file_alt"
    t.string "rich_file_file_title"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "grant_id"
    t.index ["name"], name: "index_settings_on_name"
  end

  create_table "snippets", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description"
    t.text "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "grant_id"
  end

  create_table "universities", force: :cascade do |t|
    t.string "name"
    t.string "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "grant_id"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "admin_accounts", "grants"
  add_foreign_key "grant_settings", "grants"
  add_foreign_key "grant_snippets", "grants"
end
