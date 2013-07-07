class AddLootColumnsToPlayers < ActiveRecord::Migration
  def up
    add_column :players, :armour_count, :integer, :default => 0
    add_column :players, :jewellery_count, :integer, :default => 0
    add_column :players, :weapons_count, :integer, :default => 0
    add_column :players, :adornments_count, :integer, :default => 0
    add_column :players, :dislodgers_count, :integer, :default => 0
    add_column :players, :mounts_count, :integer, :default => 0
    add_column :players, :adornment_rate, :float, :default => 0.0
    add_column :players, :dislodger_rate, :float, :default => 0.0
    add_column :players, :mount_rate, :float, :default => 0.0
    add_column :players, :attuned_rate, :float, :default => 0.0
    # Going to disassociate the item counts and remove adjustments so we'll sump up any values
    Player.reset_column_information
    Player.all.each do |player|
      player.armour_count = player.items.of_type('Armour').count +
          player.adjustments.where(:adjustment_type => 'Armour').sum(:amount)
      player.jewellery_count = player.items.of_type('Jewellery').count +
          player.adjustments.where(:adjustment_type => 'Jewellery').sum(:amount)
      player.weapons_count = player.items.of_type('Weapon').count +
          player.adjustments.where(:adjustment_type => 'Weapon').sum(:amount)
      player.adornments_count = player.items.of_type('Adornment').count +
          player.adjustments.where(:adjustment_type => 'Adornment').sum(:amount)
      player.adornments_count = player.items.of_type('Dislodger').count +
          player.adjustments.where(:adjustment_type => 'Dislodger').sum(:amount)
      player.mounts_count = player.items.of_type('Mount').count +
          player.adjustments.where(:adjustment_type => 'Mount').sum(:amount)

      player.attuned_rate = player.raids_count /
          (player.armour_count + player.jewellery_count + player.weapons_count + 1)
      player.save!
    end
  end

  def down
    remove_columns :players, :armour_count, :jewellery_count, :weapons_count, :adornments_count,
                   :dislodgers_count, :mounts_count, :adornment_rate, :dislodger_rate, :mount_rate, :attuned_rate
  end
end
