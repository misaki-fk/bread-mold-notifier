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

ActiveRecord::Schema[7.1].define(version: 2026_04_07_122729) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bread_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "breads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bread_type_id", null: false
    t.integer "total_count"
    t.integer "remaining_count"
    t.integer "daily_consumption"
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "adjustment_count", default: 0, null: false
    t.bigint "group_id", null: false
    t.index ["bread_type_id"], name: "index_breads_on_bread_type_id"
    t.index ["group_id"], name: "index_breads_on_group_id"
    t.index ["user_id"], name: "index_breads_on_user_id"
  end

  create_table "default_breads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bread_type_id", null: false
    t.integer "total_count"
    t.integer "daily_consumption", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bread_type_id"], name: "index_default_breads_on_bread_type_id"
    t.index ["user_id"], name: "index_default_breads_on_user_id", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_invitations_on_group_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bread_id", null: false
    t.string "notification_type", null: false
    t.string "message", null: false
    t.boolean "is_read", default: false, null: false
    t.datetime "notified_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bread_id"], name: "index_notifications_on_bread_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "breads", "bread_types"
  add_foreign_key "breads", "groups"
  add_foreign_key "breads", "users"
  add_foreign_key "default_breads", "bread_types"
  add_foreign_key "default_breads", "users"
  add_foreign_key "invitations", "groups"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "notifications", "breads"
  add_foreign_key "notifications", "users"
end
