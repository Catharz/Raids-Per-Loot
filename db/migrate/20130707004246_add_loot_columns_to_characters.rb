class AddLootColumnsToCharacters < ActiveRecord::Migration
  def up
    add_column :characters, :armour_count, :integer, :default => 0
    add_column :characters, :jewellery_count, :integer, :default => 0
    add_column :characters, :weapons_count, :integer, :default => 0
    add_column :characters, :adornments_count, :integer, :default => 0
    add_column :characters, :dislodgers_count, :integer, :default => 0
    add_column :characters, :mounts_count, :integer, :default => 0
    add_column :characters, :adornment_rate, :float, :default => 0.0
    add_column :characters, :dislodger_rate, :float, :default => 0.0
    add_column :characters, :mount_rate, :float, :default => 0.0
    add_column :characters, :attuned_rate, :float, :default => 0.0
    # Going to disassociate the item counts and remove adjustments so we'll sump up any values
    Character.reset_column_information
    Character.all.each do |character|
      character.armour_count = character.items.of_type('Armour').count +
          character.adjustments.where(:adjustment_type => 'Armour').sum(:amount)
      character.jewellery_count = character.items.of_type('Jewellery').count +
          character.adjustments.where(:adjustment_type => 'Jewellery').sum(:amount)
      character.weapons_count = character.items.of_type('Weapon').count +
          character.adjustments.where(:adjustment_type => 'Weapon').sum(:amount)
      character.adornments_count = character.items.of_type('Adornment').count +
          character.adjustments.where(:adjustment_type => 'Adornment').sum(:amount)
      character.adornments_count = character.items.of_type('Dislodger').count +
          character.adjustments.where(:adjustment_type => 'Dislodger').sum(:amount)
      character.mounts_count = character.items.of_type('Mount').count +
          character.adjustments.where(:adjustment_type => 'Mount').sum(:amount)

      unless character.player.nil?
        character.attuned_rate = character.player.raids_count /
            (character.armour_count + character.jewellery_count + character.weapons_count + 1)
      end
      character.save!
    end
  end

  def down
    remove_columns :characters, :armour_count, :jewellery_count, :weapons_count, :adornments_count,
                   :dislodgers_count, :mounts_count, :adornment_rate, :dislodger_rate, :mount_rate, :attuned_rate
  end
end
