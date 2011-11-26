class AddPlayerArchetype < ActiveRecord::Migration
  def self.up
    add_column :players, :archetype_id, :integer
  end

  def self.down
    remove_column :players, :archetype_id
  end
end
