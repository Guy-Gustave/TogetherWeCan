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

ActiveRecord::Schema.define(version: 2022_02_16_101920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_accounts", force: :cascade do |t|
    t.bigint "ishami_bank_account_id", null: false
    t.decimal "total_admin_amount", default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ishami_bank_account_id"], name: "index_admin_accounts_on_ishami_bank_account_id"
  end

  create_table "capitals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.string "capital_name"
    t.integer "period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "purchase_id", null: false
    t.integer "gift_counter", default: 0
    t.string "recreation_date"
    t.string "capital_status", default: "original"
    t.index ["purchase_id"], name: "index_capitals_on_purchase_id"
    t.index ["user_id"], name: "index_capitals_on_user_id"
  end

  create_table "gifts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "capital_id", null: false
    t.decimal "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "purchase_id", null: false
    t.index ["capital_id"], name: "index_gifts_on_capital_id"
    t.index ["purchase_id"], name: "index_gifts_on_purchase_id"
    t.index ["user_id"], name: "index_gifts_on_user_id"
  end

  create_table "ishami_account_balances", force: :cascade do |t|
    t.decimal "saving_amount"
    t.decimal "total_amount"
    t.bigint "ishami_bank_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "total_gift_amount", default: "0.0"
    t.index ["ishami_bank_account_id"], name: "index_ishami_account_balances_on_ishami_bank_account_id"
  end

  create_table "ishami_bank_accounts", force: :cascade do |t|
    t.string "account_number"
    t.string "bank_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.string "purchase_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "savings_amount"
    t.integer "next_capitals"
    t.integer "week_number", default: 0
    t.decimal "purchase_gift_amount", default: "0.0"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "savings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "capital_id", null: false
    t.decimal "savings_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["capital_id"], name: "index_savings_on_capital_id"
    t.index ["user_id"], name: "index_savings_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "capital_id", null: false
    t.decimal "amount"
    t.string "transaction_type"
    t.integer "week_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transaction_number"
    t.bigint "gift_id"
    t.bigint "ishami_account_balance_id", null: false
    t.index ["capital_id"], name: "index_transactions_on_capital_id"
    t.index ["gift_id"], name: "index_transactions_on_gift_id"
    t.index ["ishami_account_balance_id"], name: "index_transactions_on_ishami_account_balance_id"
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

  add_foreign_key "admin_accounts", "ishami_bank_accounts"
  add_foreign_key "capitals", "purchases"
  add_foreign_key "capitals", "users"
  add_foreign_key "gifts", "capitals"
  add_foreign_key "gifts", "purchases"
  add_foreign_key "gifts", "users"
  add_foreign_key "ishami_account_balances", "ishami_bank_accounts"
  add_foreign_key "purchases", "users"
  add_foreign_key "savings", "capitals"
  add_foreign_key "savings", "users"
  add_foreign_key "transactions", "capitals"
  add_foreign_key "transactions", "gifts"
  add_foreign_key "transactions", "ishami_account_balances"
end
