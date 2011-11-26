class ArchetypesItems < ActiveRecord::Migration
  def self.up
    create_table :archetypes_items, :id => false do |t|
      t.integer :archetype_id
      t.integer :item_id
    end
  end

  def self.down
    drop_table :archetypes_items
  end
end
