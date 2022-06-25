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

ActiveRecord::Schema[7.0].define(version: 2022_06_20_201917) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rivers", id: :integer, force: :cascade do |t|
    t.float "put_in_lat"
    t.float "put_in_long"
    t.float "take_out_lat"
    t.float "take_out_long"
    t.text "river"
    t.text "section"
    t.integer "source_id"
    t.boolean "skipped", default: false
    t.text "origin_id"
    t.integer "match_id"
    t.string "match_type"
    t.string "grade"
    t.index ["match_id"], name: "index_rivers_on_match_id"
    t.index ["origin_id"], name: "index_rivers_on_origin_id"
    t.index ["river"], name: "index_rivers_on_river"
    t.index ["source_id"], name: "index_rivers_on_source_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  # create_table "spatial_ref_sys", primary_key: "srid", id: :integer, default: nil, force: :cascade do |t|
  #   t.string "auth_name", limit: 256
  #   t.integer "auth_srid"
  #   t.string "srtext", limit: 2048
  #   t.string "proj4text", limit: 2048
  #   t.check_constraint "srid > 0 AND srid <= 998999", name: "spatial_ref_sys_srid_check"
  # end

end
