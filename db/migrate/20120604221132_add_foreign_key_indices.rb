class AddForeignKeyIndices < ActiveRecord::Migration
  def up
    add_index :adjustments, :adjustable_id

    add_index :archetypes_items, :archetype_id
    add_index :archetypes_items, :item_id

    add_index :character_instances, :character_id
    add_index :character_instances, :instance_id

    add_index :character_types, :character_id

    add_index :characters, :archetype_id
    add_index :characters, :player_id

    add_index :drops, :zone_id
    add_index :drops, :mob_id
    add_index :drops, :character_id
    add_index :drops, :item_id
    add_index :drops, :loot_type_id
    add_index :drops, :instance_id

    add_index :instances, :zone_id
    add_index :instances, :raid_id

    add_index :items, :loot_type_id

    add_index :items_slots, :item_id
    add_index :items_slots, :slot_id

    add_index :link_categories_links, :link_category_id
    add_index :link_categories_links, :link_id

    add_index :mobs, :zone_id
    add_index :mobs, :difficulty_id

    add_index :pages, :parent_id

    add_index :players, :rank_id

    add_index :zones, :difficulty_id
  end

  def down
  end
end
