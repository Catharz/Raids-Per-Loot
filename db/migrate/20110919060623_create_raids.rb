class CreateRaids < ActiveRecord::Migration
  def self.up
    create_table :raids do |t|
      t.date :raid_date
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def self.down
    drop_table :raids
  end
end
