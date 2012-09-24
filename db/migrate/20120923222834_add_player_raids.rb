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
  class PlayerRaid < ActiveRecord::Base
    belongs_to :player
    belongs_to :raid
  end

  class Player < ActiveRecord::Base
    has_many :characters, :inverse_of => :player
    has_many :character_instances, :through => :characters
    has_many :instances, :through => :character_instances
    has_many :player_raids, :inverse_of => :player
    has_many :raids, :through => :player_raids
  end
  class Raid < ActiveRecord::Base
    has_many :instances, :inverse_of => :raid
    has_many :characters, :through => :instances, :uniq => true
    has_many :player_raids, :inverse_of => :raid
    has_many :players, :through => :player_raids
  end

  def up
    create_table :player_raids, :id => false do |t|
      t.references :player
      t.references :raid
      t.boolean :signed_up, default: true
      t.boolean :punctual, default: true
      t.string :status, default: 'a'
    end
    add_index :player_raids, :player_id
    add_index :player_raids, :raid_id
    Raid.includes(:players).order(:raid_date).each do |raid|
      raid.players.each do |player|
        sql = "insert into player_raids " +
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
