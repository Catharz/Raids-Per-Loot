class AddPlayerRaids < ActiveRecord::Migration
  class Player < ActiveRecord::Base
    has_many :characters, :inverse_of => :player
    has_many :character_instances, :through => :characters
    has_many :instances, :through => :character_instances
    has_many :raids, :through => :instances, :uniq => true
  end
  class Raid < ActiveRecord::Base
    has_many :instances, :inverse_of => :raid
    has_many :characters, :through => :instances, :uniq => true
    has_many :players, :through => :characters, :uniq => true
  end

  def up
    create_table :player_raids do |t|
      t.references :player
      t.references :raid
      t.boolean :signed_up, default: true
      t.boolean :punctual, default: true
      t.string :status, default: 'a'
    end
    add_index :player_raids, :player_id
    add_index :player_raids, :raid_id
    Raid.eager_load(:players).order(:raid_date).each do |raid|
      puts "inserting players for raid on #{raid.raid_date}"
      raid.players.each do |player|
        puts "adding player: #{player.name}"
        sql = "insert into player_raids (player_id, raid_id) " +
              "select #{player.id}, #{raid.id} " +
              "where not exists (select player_id, raid_id from player_raids " +
                                "where player_id = #{player.id} and raid_id = #{raid.id})"
        execute sql
      end
    end
  end

  def down
    drop_table :player_raids
  end
end
