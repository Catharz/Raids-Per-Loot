class AddRaidTypeToRaids < ActiveRecord::Migration
  def up
    normal = RaidType.find_or_create_by_name('Normal')
    add_column :raids, :raid_type_id, :integer, references: :raid_types, null: false, default: normal.id
  end

  def down
    remove_column :raids, :raid_type_id
  end
end
