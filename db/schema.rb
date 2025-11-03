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

ActiveRecord::Schema[8.0].define(version: 2025_11_02_170140) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "alert_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "alert_id", null: false
    t.string "notification_method"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id"], name: "index_alert_subscriptions_on_alert_id"
    t.index ["user_id"], name: "index_alert_subscriptions_on_user_id"
  end

  create_table "alerts", force: :cascade do |t|
    t.string "title"
    t.text "message"
    t.string "severity"
    t.string "category"
    t.integer "status"
    t.bigint "user_id", null: false
    t.datetime "acknowledged_at"
    t.datetime "resolved_at"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_alerts_on_category"
    t.index ["severity", "created_at"], name: "index_alerts_on_severity_and_created_at"
    t.index ["user_id", "status"], name: "index_alerts_on_user_id_and_status"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alert_subscriptions", "alerts"
  add_foreign_key "alert_subscriptions", "users"
  add_foreign_key "alerts", "users"
end
