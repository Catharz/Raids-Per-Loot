class PlayersRaids < ActiveRecord::Migration
  def self.up
    create_table :players_raids, :id => false do |t|
      t.integer :player_id
      t.integer :raid_id
    end
  end

  def self.down
    drop_table :players_raids
  end
end
