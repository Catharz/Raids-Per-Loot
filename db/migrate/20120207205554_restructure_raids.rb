class RestructureRaids < ActiveRecord::Migration
  def self.up
    Raid.delete_all

    Instance.all.each do |instance|
      raid = Raid.find_by_raid_date(instance.start_time.to_date)
      raid ||= Raid.create!(:raid_date => instance.start_time.to_date)
      instance.raid_id = raid.id
      instance.save
    end

    remove_column :raids, :zone_id
    remove_column :raids, :start_time
    remove_column :raids, :end_time
    Raid.reset_column_information

    remove_column :drops, :raid_id
    Drop.reset_column_information

    drop_table :players_raids
  end

  def self.down
    add_column :drops, :raid_id, :integer
    Drop.reset_column_information

    create_table :players_raids, :id => false do |t|
      t.integer :player_id
      t.integer :raid_id
    end

    add_column :raids, :zone_id, :integer
    add_column :raids, :start_time, :datetime
    add_column :raids, :end_time, :datetime
    Raid.reset_column_information

    Raid.delete_all

    Instance.all.each do |instance|
      raid = Raid.create!(:zone => instance.zone,
                          :raid_date => instance.start_time.to_date,
                          :start_time => instance.start_time,
                          :end_time => instance.end_time)
      raid.players << instance.players
      raid.drops << instance.drops
      raid.save
    end
  end
end
