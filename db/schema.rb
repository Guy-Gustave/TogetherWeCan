# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_03_170759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_accounts", force: :cascade do |t|
    t.bigint "gift_id", null: false
    t.integer "week_number"
    t.decimal "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gift_id"], name: "index_admin_accounts_on_gift_id"
  end

  create_table "capitals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.string "capital_name"
    t.decimal "savings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_capitals_on_user_id"
  end

  create_table "gifts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "capital_id", null: false
    t.decimal "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["capital_id"], name: "index_gifts_on_capital_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "ishami_accounts", force: :cascade do |t|
    t.integer "week_number"
    t.decimal "total_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "capital_id", null: false
    t.decimal "amount"
    t.string "transaction_type"
    t.integer "week_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transaction_number"
    t.bigint "gift_id", null: false
    t.index ["capital_id"], name: "index_transactions_on_capital_id"
    t.index ["gift_id"], name: "index_transactions_on_gift_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "telephone_number"
    t.string "account_number"
    t.string "email"
    t.string "password_digest"
    t.string "bank_name"
    t.string "country"
    t.string "identification_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "admin_accounts", "gifts"
  add_foreign_key "capitals", "users"
  add_foreign_key "gifts", "capitals"
  add_foreign_key "gifts", "users"
  add_foreign_key "transactions", "capitals"
  add_foreign_key "transactions", "gifts"
end
