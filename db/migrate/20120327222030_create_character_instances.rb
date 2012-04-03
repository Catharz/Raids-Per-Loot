class CreateCharacterInstances < ActiveRecord::Migration
  class Player < ActiveRecord::Base
    has_and_belongs_to_many :instances
  end
  class Instance < ActiveRecord::Base
    has_and_belongs_to_many :players
  end
  def up
    create_table :character_instances do |t|
      t.integer :character_id
      t.integer :instance_id
    end
    Player.all.each do |player|
      character = Character.find_by_name(player.name)
      if character
        player.instances.each do |instance|
          character_instance = CharacterInstance.create(:instance_id => instance.id, :character_id => character.id)
          character_instance.save
        end
      else
        raise "Cannot perform migration, could not find character with player name:  #{player.name}"
      end
    end
  end

  def down
    drop_table :character_instances
  end
end