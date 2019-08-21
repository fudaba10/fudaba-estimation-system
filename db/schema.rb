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

ActiveRecord::Schema.define(version: 2019_08_20_140453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "customer_name", null: false
    t.string "customer_name_kana", null: false
    t.string "customer_initial", null: false
    t.string "postal_code"
    t.string "address"
    t.string "tel"
    t.string "fax"
    t.string "remarks"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_name", null: false
    t.string "employee_name_kana", null: false
    t.string "login_id", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estimate_details", force: :cascade do |t|
    t.string "product_name", null: false
    t.string "detail"
    t.integer "quantity", default: 1, null: false
    t.string "kind", default: "PC", null: false
    t.integer "unit_price", default: 0, null: false
    t.integer "total_fee", default: 0, null: false
    t.integer "tax", default: 0, null: false
    t.integer "tax_amount", default: 0, null: false
    t.string "delivery_period"
    t.bigint "vendor_id", null: false
    t.bigint "estimate_header_id", null: false
    t.integer "estimate_detail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["estimate_header_id"], name: "index_estimate_details_on_estimate_header_id"
    t.index ["vendor_id"], name: "index_estimate_details_on_vendor_id"
  end

  create_table "estimate_headers", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "customer_person", null: false
    t.string "estimate_id", null: false
    t.bigint "employee_id", null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_estimate_headers_on_customer_id"
    t.index ["employee_id"], name: "index_estimate_headers_on_employee_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "vendor_name", null: false
    t.string "vendor_name_kana", null: false
    t.string "postal_code"
    t.string "address"
    t.string "tel"
    t.string "fax"
    t.boolean "is_deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "estimate_details", "estimate_headers"
  add_foreign_key "estimate_details", "vendors"
  add_foreign_key "estimate_headers", "customers"
  add_foreign_key "estimate_headers", "employees"
end
