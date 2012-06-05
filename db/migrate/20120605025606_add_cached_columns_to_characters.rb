class AddCachedColumnsToCharacters < ActiveRecord::Migration
  def up
    add_column :characters, :instances_count, :integer, :default => 0
    add_column :characters, :raids_count, :integer, :default => 0
    add_column :characters, :armour_rate, :float, :default => 0.0
    add_column :characters, :jewellery_rate, :float, :default => 0.0
    add_column :characters, :weapon_rate, :float, :default => 0.0
    Character.reset_column_information
    Character.all.each do |character|
      character.instances_count = character.instances.count + character.adjustments.where(:adjustment_type => "Instances").sum(:amount)
      character.raids_count = character.raids.count + character.adjustments.where(:adjustment_type => "Raids").sum(:amount)
      character.armour_rate = character.loot_rate("Armour") + character.adjustments.where(:adjustment_type => "Armour").sum(:amount)
      character.jewellery_rate = character.loot_rate("Jewellery") + character.adjustments.where(:adjustment_type => "Jewellery").sum(:amount)
      character.weapon_rate = character.loot_rate("Weapon") + character.adjustments.where(:adjustment_type => "Weapon").sum(:amount)
      character.save!
    end
  end

  def down
    remove_column :characters, :instances_count
    remove_column :characters, :raids_count
    remove_column :characters, :armour_rate
    remove_column :characters, :jewellery_rate
    remove_column :characters, :weapon_rate
  end
end
