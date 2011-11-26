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

ActiveRecord::Schema.define(:version => 20111126134512) do

  create_table "archetypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_class_id"
  end

  create_table "archetypes_items", :id => false, :force => true do |t|
    t.integer "archetype_id"
    t.integer "item_id"
  end

  create_table "drops", :force => true do |t|
    t.string   "zone_name"
    t.string   "mob_name"
    t.string   "player_name"
    t.string   "item_name"
    t.string   "eq2_item_id"
    t.datetime "drop_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id"
    t.integer  "raid_id"
    t.integer  "mob_id"
    t.integer  "player_id"
    t.integer  "item_id"
    t.boolean  "assigned"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "eq2_item_id"
    t.string   "info_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loot_type_id"
  end

  create_table "items_slots", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "slot_id"
  end

  create_table "link_categories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "link_categories_links", :id => false, :force => true do |t|
    t.integer "link_category_id"
    t.integer "link_id"
  end

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
  end

  create_table "mobs", :force => true do |t|
    t.string   "name"
    t.text     "strategy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "main_character_id"
    t.integer  "archetype_id"
    t.integer  "rank_id"
  end

  create_table "players_raids", :id => false, :force => true do |t|
    t.integer "player_id"
    t.integer "raid_id"
  end

  create_table "raids", :force => true do |t|
    t.date     "raid_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id"
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
  end

  create_table "zones_mobs", :id => false, :force => true do |t|
    t.integer "zone_id"
    t.integer "mob_id"
  end

end
