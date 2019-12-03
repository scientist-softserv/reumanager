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

ActiveRecord::Schema.define(version: 2019_12_02_234952) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
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

  create_table "application_forms", force: :cascade do |t|
    t.json "form_schema"
    t.json "form_ui_schema"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "status", default: 0, null: false
    t.jsonb "important_paths"
  end

  create_table "applications", force: :cascade do |t|
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "recommender_info"
    t.datetime "submitted_at"
    t.datetime "completed_at"
    t.string "state"
  end

  create_table "fields", force: :cascade do |t|
    t.string "kind", default: "Fields::ShortText", null: false
    t.jsonb "config", default: {}, null: false
    t.integer "section_id"
    t.integer "order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "important"
    t.jsonb "dependant_config", default: {}
    t.index ["section_id"], name: "index_fields_on_section_id"
  end

  create_table "grants", id: :serial, force: :cascade do |t|
    t.string "program_title"
    t.string "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "contact_email"
    t.string "contact_password"
    t.string "coupon_code"
    t.datetime "credit_card_charged_at"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "grant_id"
    t.string "university_or_institution"
    t.string "department"
    t.string "program_title"
    t.string "contact_name"
    t.string "email"
    t.string "phone"
    t.string "billing_name"
    t.text "billing_address"
    t.string "billing_email"
    t.string "billing_phone"
    t.string "po_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grant_id"], name: "index_invoices_on_grant_id"
  end

  create_table "recommender_forms", force: :cascade do |t|
    t.integer "status"
    t.string "name"
    t.jsonb "form_json_schema"
    t.jsonb "form_ui_schema"
    t.datetime "updated_cache_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recommenders_count", default: 1, null: false
  end

  create_table "recommender_statuses", force: :cascade do |t|
    t.string "email"
    t.datetime "last_sent_at"
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", default: -> { "md5((random())::text)" }, null: false
    t.jsonb "data", default: {}
    t.integer "application_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sections", force: :cascade do |t|
    t.text "title", null: false
    t.boolean "repeating", default: false, null: false
    t.integer "application_form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recommender_form_id"
    t.string "important"
    t.integer "count", default: 1, null: false
    t.integer "order"
    t.index ["application_form_id"], name: "index_sections_on_application_form_id"
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
    t.string "kind"
    t.index ["name"], name: "index_settings_on_name"
  end

  create_table "snippets", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.text "description"
    t.text "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "grant_id"
    t.string "kind"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "application_id"
    t.string "subdomain"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
