class RemoveTextFieldsFromDrops < ActiveRecord::Migration
  def up
    remove_column :drops, :zone_name
    remove_column :drops, :mob_name
    remove_column :drops, :character_name
    remove_column :drops, :item_name
    remove_column :drops, :eq2_item_id
    remove_column :drops, :assigned_to_character
    remove_column :drops, :loot_type_name
    remove_column :drops, :info_url
  end

  def down
    add_column :drops, :zone_name, :string
    add_column :drops, :mob_name, :string
    add_column :drops, :character_name, :string
    add_column :drops, :item_name, :string
    add_column :drops, :eq2_item_id, :string
    add_column :drops, :assigned_to_character, :string
    add_column :drops, :loot_type_name, :string
    Drop.reset_column_information

    Drop.all.each do |drop|
      zone = Zone.find_by_id(drop.zone_id)
      mob = Mob.find_by_id(drop.mob_id)
      character = Character.find_by_id(drop.character_id)
      item = Item.find_by_id(drop.item_id)
      loot_type = LootType.find_by_id(drop.loot_type_id)

      if zone and mob and character and item and loot_type
        drop.zone_name = zone.name
        drop.mob_name = mob.name
        drop.character_name = character.name
        drop.item_name = item.name
        drop.eq2_item_id = item.eq2_item_id
        drop.loot_type_name = loot_type.name
        drop.save!
      end
    end
  end
end
