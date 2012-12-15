# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121215010329) do

  create_table "adjustments", :force => true do |t|
    t.date     "adjustment_date"
    t.string   "adjustment_type"
    t.integer  "amount"
    t.string   "reason"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adjustments", ["adjustable_id"], :name => "index_adjustments_on_adjustable_id"

  create_table "archetypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  create_table "archetypes_items", :force => true do |t|
    t.integer  "archetype_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "archetypes_items", ["archetype_id"], :name => "index_archetypes_items_on_archetype_id"
  add_index "archetypes_items", ["item_id"], :name => "index_archetypes_items_on_item_id"

  create_table "character_instances", :force => true do |t|
    t.integer "character_id"
    t.integer "instance_id"
  end

  add_index "character_instances", ["character_id"], :name => "index_character_instances_on_character_id"
  add_index "character_instances", ["instance_id"], :name => "index_character_instances_on_instance_id"

  create_table "character_types", :force => true do |t|
    t.integer  "character_id"
    t.date     "effective_date"
    t.string   "char_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "normal_penalty"
    t.integer  "progression_penalty"
  end

  add_index "character_types", ["character_id"], :name => "index_character_types_on_character_id"

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.integer  "player_id"
    t.integer  "archetype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "char_type"
    t.integer  "instances_count", :default => 0
    t.integer  "raids_count",     :default => 0
    t.float    "armour_rate",     :default => 0.0
    t.float    "jewellery_rate",  :default => 0.0
    t.float    "weapon_rate",     :default => 0.0
  end

  add_index "characters", ["archetype_id"], :name => "index_characters_on_archetype_id"
  add_index "characters", ["player_id"], :name => "index_characters_on_player_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "difficulties", :force => true do |t|
    t.string   "name"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drops", :force => true do |t|
    t.datetime "drop_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id"
    t.integer  "mob_id"
    t.integer  "character_id"
    t.integer  "item_id"
    t.integer  "loot_type_id"
    t.integer  "instance_id"
    t.string   "loot_method",  :default => "n"
    t.text     "chat"
    t.string   "log_line"
  end

  add_index "drops", ["character_id"], :name => "index_drops_on_character_id"
  add_index "drops", ["instance_id"], :name => "index_drops_on_instance_id"
  add_index "drops", ["item_id"], :name => "index_drops_on_item_id"
  add_index "drops", ["log_line"], :name => "index_drops_on_log_line"
  add_index "drops", ["loot_type_id"], :name => "index_drops_on_loot_type_id"
  add_index "drops", ["mob_id"], :name => "index_drops_on_mob_id"
  add_index "drops", ["zone_id"], :name => "index_drops_on_zone_id"

  create_table "external_data", :force => true do |t|
    t.integer "retrievable_id"
    t.string  "retrievable_type"
    t.text    "data"
  end

  create_table "instances", :force => true do |t|
    t.integer  "zone_id"
    t.integer  "raid_id"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instances", ["raid_id"], :name => "index_instances_on_raid_id"
  add_index "instances", ["zone_id"], :name => "index_instances_on_zone_id"

  create_table "instances_players", :id => false, :force => true do |t|
    t.integer "instance_id"
    t.integer "player_id"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "eq2_item_id"
    t.string   "info_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loot_type_id"
  end

  add_index "items", ["loot_type_id"], :name => "index_items_on_loot_type_id"

  create_table "items_slots", :force => true do |t|
    t.integer  "item_id"
    t.integer  "slot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items_slots", ["item_id"], :name => "index_items_slots_on_item_id"
  add_index "items_slots", ["slot_id"], :name => "index_items_slots_on_slot_id"

  create_table "link_categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_categories_links", :force => true do |t|
    t.integer  "link_category_id"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "link_categories_links", ["link_category_id"], :name => "index_link_categories_links_on_link_category_id"
  add_index "link_categories_links", ["link_id"], :name => "index_link_categories_links_on_link_id"

  create_table "links", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loot_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_loot_method", :limit => 1, :default => "n"
  end

  create_table "mobs", :force => true do |t|
    t.string   "name"
    t.text     "strategy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id"
    t.integer  "difficulty_id"
    t.string   "alias"
  end

  add_index "mobs", ["difficulty_id"], :name => "index_mobs_on_difficulty_id"
  add_index "mobs", ["zone_id"], :name => "index_mobs_on_zone_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.integer  "parent_id"
    t.string   "navlabel"
    t.integer  "position"
    t.boolean  "redirect"
    t.string   "action_name"
    t.string   "controller_name"
    t.integer  "pages_count",     :default => 0, :null => false
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"

  create_table "player_raids", :force => true do |t|
    t.integer "player_id"
    t.integer "raid_id"
    t.boolean "signed_up", :default => true
    t.boolean "punctual",  :default => true
    t.string  "status",    :default => "a"
  end

  add_index "player_raids", ["player_id"], :name => "index_player_raids_on_player_id"
  add_index "player_raids", ["raid_id"], :name => "index_player_raids_on_raid_id"

  create_table "players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank_id"
    t.integer  "instances_count", :default => 0
    t.integer  "raids_count",     :default => 0
    t.float    "armour_rate",     :default => 0.0
    t.float    "jewellery_rate",  :default => 0.0
    t.float    "weapon_rate",     :default => 0.0
  end

  add_index "players", ["rank_id"], :name => "index_players_on_rank_id"

  create_table "raids", :force => true do |t|
    t.date     "raid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", :force => true do |t|
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slots", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.string   "activation_code",           :limit => 40
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "zones", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "difficulty_id"
  end

  add_index "zones", ["difficulty_id"], :name => "index_zones_on_difficulty_id"

  create_table "zones_mobs", :id => false, :force => true do |t|
    t.integer "zone_id"
    t.integer "mob_id"
  end

end
