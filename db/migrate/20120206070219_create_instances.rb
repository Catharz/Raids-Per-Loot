class CreateInstances < ActiveRecord::Migration
  def self.up
    # Create the new instances table
    create_table :instances do |t|
      t.references :zone
      t.references :raid
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end

    # Create the drops.instance relationship
    add_column :drops, :instance_id, :integer
    Drop.reset_column_information

    # Create the instances.players relationship
    create_table :instances_players, :id => false do |t|
      t.references :instance
      t.references :player
    end
  end

  def self.down
    remove_column :drops, :instance_id
    Drop.reset_column_information

    drop_table :instances_players
    drop_table :instances
  end
end
