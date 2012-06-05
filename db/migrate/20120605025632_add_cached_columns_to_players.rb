class AddCachedColumnsToPlayers < ActiveRecord::Migration
  def up
    add_column :players, :instances_count, :integer, :default => 0
    add_column :players, :raids_count, :integer, :default => 0
    add_column :players, :armour_rate, :float, :default => 0.0
    add_column :players, :jewellery_rate, :float, :default => 0.0
    add_column :players, :weapon_rate, :float, :default => 0.0
    Player.reset_column_information
    Player.all.each do |player|
      player.instances_count = player.instances.count + player.adjustments.where(:adjustment_type => "Instances").sum(:amount)
      player.raids_count = player.raids.count + player.adjustments.where(:adjustment_type => "Raids").sum(:amount)
      player.armour_rate = player.loot_rate("Armour") + player.adjustments.where(:adjustment_type => "Armour").sum(:amount)
      player.jewellery_rate = player.loot_rate("Jewellery") + player.adjustments.where(:adjustment_type => "Jewellery").sum(:amount)
      player.weapon_rate = player.loot_rate("Weapon") + player.adjustments.where(:adjustment_type => "Weapon").sum(:amount)
      player.save!
    end
  end

  def down
    remove_column :players, :instances_count
    remove_column :players, :raids_count
    remove_column :players, :armour_rate
    remove_column :players, :jewellery_rate
    remove_column :players, :weapon_rate
  end
end
