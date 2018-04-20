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

ActiveRecord::Schema.define(version: 2018_04_20_072117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gutentag_taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_gutentag_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "unique_taggings", unique: true
    t.index ["taggable_type", "taggable_id"], name: "index_gutentag_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "gutentag_tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0, null: false
    t.integer "instances_count", default: 0
    t.index ["name"], name: "index_gutentag_tags_on_name", unique: true
    t.index ["taggings_count"], name: "index_gutentag_tags_on_taggings_count"
  end

  create_table "instances", force: :cascade do |t|
    t.string "host"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "toots", force: :cascade do |t|
    t.bigint "instance_id"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guid"
    t.index ["guid"], name: "index_toots_on_guid"
    t.index ["instance_id"], name: "index_toots_on_instance_id"
  end

  add_foreign_key "toots", "instances"

  create_view "trending_tags", materialized: true,  sql_definition: <<-SQL
      SELECT DISTINCT gutentag_tags.id,
      gutentag_tags.name,
      gutentag_tags.created_at,
      gutentag_tags.updated_at,
      gutentag_tags.taggings_count,
      (( SELECT count(*) AS count
             FROM gutentag_taggings gutentag_taggings_1
            WHERE ((gutentag_taggings_1.tag_id = gutentag_tags.id) AND (timezone('UTC'::text, (gutentag_taggings_1.created_at)::timestamp with time zone) > (now() - '06:00:00'::interval)))) - ( SELECT count(*) AS count
             FROM gutentag_taggings gutentag_taggings_1
            WHERE ((gutentag_taggings_1.tag_id = gutentag_tags.id) AND (gutentag_taggings_1.created_at <= (timezone('UTC'::text, now()) - '06:00:00'::interval)) AND (gutentag_taggings_1.created_at > (timezone('UTC'::text, now()) - '12:00:00'::interval))))) AS hottness
     FROM (gutentag_tags
       LEFT JOIN gutentag_taggings ON ((gutentag_tags.id = gutentag_taggings.tag_id)))
    WHERE ((gutentag_taggings.created_at >= (timezone('UTC'::text, now()) - '12:00:00'::interval)) AND (gutentag_tags.taggings_count > 5));
  SQL

end
