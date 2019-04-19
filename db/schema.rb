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

ActiveRecord::Schema.define(version: 20190419225737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_records", id: :serial, force: :cascade do |t|
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

  create_table "addresses", id: :serial, force: :cascade do |t|
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

  create_table "applicants", id: :serial, force: :cascade do |t|
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

  create_table "application_forms", force: :cascade do |t|
    t.json "form_schema"
    t.json "form_ui_schema"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "awards", id: :serial, force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.text "description"
    t.integer "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grants", id: :serial, force: :cascade do |t|
    t.string "program_title"
    t.string "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "contact_email"
    t.string "contact_password"
    t.string "coupon_code"
  end

  create_table "program_admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_program_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_program_admins_on_reset_password_token", unique: true
  end

  create_table "rails_admin_histories", id: :serial, force: :cascade do |t|
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

  create_table "recommendations", id: :serial, force: :cascade do |t|
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

  create_table "recommenders", id: :serial, force: :cascade do |t|
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

  create_table "refinery_authentication_devise_roles", id: :serial, force: :cascade do |t|
    t.string "title"
  end

  create_table "refinery_authentication_devise_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id", "user_id"], name: "refinery_roles_users_role_id_user_id"
    t.index ["user_id", "role_id"], name: "refinery_roles_users_user_id_role_id"
  end

  create_table "refinery_authentication_devise_user_plugins", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "position"
    t.index ["name"], name: "index_refinery_authentication_devise_user_plugins_on_name"
    t.index ["user_id", "name"], name: "refinery_user_plugins_user_id_name", unique: true
  end

  create_table "refinery_authentication_devise_users", id: :serial, force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "sign_in_count"
    t.datetime "remember_created_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.string "full_name"
    t.index ["id"], name: "index_refinery_authentication_devise_users_on_id"
    t.index ["slug"], name: "index_refinery_authentication_devise_users_on_slug"
  end

  create_table "refinery_image_translations", force: :cascade do |t|
    t.integer "refinery_image_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_alt"
    t.string "image_title"
    t.index ["locale"], name: "index_refinery_image_translations_on_locale"
    t.index ["refinery_image_id"], name: "index_refinery_image_translations_on_refinery_image_id"
  end

  create_table "refinery_images", id: :serial, force: :cascade do |t|
    t.string "image_mime_type"
    t.string "image_name"
    t.integer "image_size"
    t.integer "image_width"
    t.integer "image_height"
    t.string "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "refinery_page_part_translations", force: :cascade do |t|
    t.integer "refinery_page_part_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.index ["locale"], name: "index_refinery_page_part_translations_on_locale"
    t.index ["refinery_page_part_id"], name: "index_refinery_page_part_translations_on_refinery_page_part_id"
  end

  create_table "refinery_page_parts", id: :serial, force: :cascade do |t|
    t.integer "refinery_page_id"
    t.string "slug"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "title"
    t.index ["id"], name: "index_refinery_page_parts_on_id"
    t.index ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id"
  end

  create_table "refinery_page_translations", force: :cascade do |t|
    t.integer "refinery_page_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "custom_slug"
    t.string "menu_title"
    t.string "slug"
    t.index ["locale"], name: "index_refinery_page_translations_on_locale"
    t.index ["refinery_page_id"], name: "index_refinery_page_translations_on_refinery_page_id"
  end

  create_table "refinery_pages", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.string "path"
    t.boolean "show_in_menu", default: true
    t.string "link_url"
    t.string "menu_match"
    t.boolean "deletable", default: true
    t.boolean "draft", default: false
    t.boolean "skip_to_first_child", default: false
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.string "view_template"
    t.string "layout_template"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["depth"], name: "index_refinery_pages_on_depth"
    t.index ["id"], name: "index_refinery_pages_on_id"
    t.index ["lft"], name: "index_refinery_pages_on_lft"
    t.index ["parent_id"], name: "index_refinery_pages_on_parent_id"
    t.index ["rgt"], name: "index_refinery_pages_on_rgt"
  end

  create_table "refinery_resource_translations", force: :cascade do |t|
    t.integer "refinery_resource_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_title"
    t.index ["locale"], name: "index_refinery_resource_translations_on_locale"
    t.index ["refinery_resource_id"], name: "index_refinery_resource_translations_on_refinery_resource_id"
  end

  create_table "refinery_resources", id: :serial, force: :cascade do |t|
    t.string "file_mime_type"
    t.string "file_name"
    t.integer "file_size"
    t.string "file_uid"
    t.string "file_ext"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rich_rich_files", id: :serial, force: :cascade do |t|
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

  create_table "seo_meta", id: :serial, force: :cascade do |t|
    t.integer "seo_meta_id"
    t.string "seo_meta_type"
    t.string "browser_title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_seo_meta_on_id"
    t.index ["seo_meta_id", "seo_meta_type"], name: "id_type_index_on_seo_meta"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.text "description"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "grant_id"
    t.index ["name"], name: "index_settings_on_name"
  end

  create_table "snippets", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.text "description"
    t.text "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "grant_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.boolean "is_super_admin", default: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
