class AddDefaultLootTypes < ActiveRecord::Migration
  @loot_types = ['Armour', 'Jewellery', 'Weapon', 'Adornment']

  def self.up
    @loot_types.each do |loot_type|
      if !LootType.find_by_name(loot_type)
        LootType.create(:name => loot_type)
      end
    end
  end

  def self.down
    @loot_types.each do |loot_type|
      LootType.find_by_name!(loot_type).delete
    end
  end
end
