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

ActiveRecord::Schema.define(version: 20180528155540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "common_names", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "species_id", null: false
    t.integer "confidence", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_common_names_on_name"
    t.index ["species_id"], name: "index_common_names_on_species_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_families_on_order_id"
  end

  create_table "genus", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_genus_on_family_id"
  end

  create_table "kingdoms", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "t_class_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["t_class_id"], name: "index_orders_on_t_class_id"
  end

  create_table "phylums", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "kingdom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kingdom_id"], name: "index_phylums_on_kingdom_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.binary "data", null: false
    t.string "content_type", null: false
    t.bigint "sighting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sighting_id"], name: "index_pictures_on_sighting_id", unique: true
  end

  create_table "sighting_challenges", force: :cascade do |t|
    t.bigint "sighting_id"
    t.bigint "species_id"
    t.bigint "user_id"
    t.string "justification", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sighting_id"], name: "index_sighting_challenges_on_sighting_id"
    t.index ["species_id"], name: "index_sighting_challenges_on_species_id"
    t.index ["user_id"], name: "index_sighting_challenges_on_user_id"
  end

  create_table "sightings", force: :cascade do |t|
    t.bigint "species_id", null: false
    t.decimal "geoLatitude", null: false
    t.decimal "geoLongitude", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_id"], name: "index_sightings_on_species_id"
    t.index ["user_id"], name: "index_sightings_on_user_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "genus_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genus_id"], name: "index_species_on_genus_id"
    t.index ["name"], name: "index_species_on_name"
  end

  create_table "t_classes", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "phylum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phylum_id"], name: "index_t_classes_on_phylum_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", null: false
    t.string "provider"
    t.string "uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "common_names", "species"
  add_foreign_key "families", "orders"
  add_foreign_key "genus", "families"
  add_foreign_key "orders", "t_classes"
  add_foreign_key "phylums", "kingdoms"
  add_foreign_key "pictures", "sightings"
  add_foreign_key "sighting_challenges", "sightings"
  add_foreign_key "sighting_challenges", "species"
  add_foreign_key "sighting_challenges", "users"
  add_foreign_key "sightings", "species"
  add_foreign_key "sightings", "users"
  add_foreign_key "species", "genus", column: "genus_id"
  add_foreign_key "t_classes", "phylums"
end
