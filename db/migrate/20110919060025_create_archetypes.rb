class CreateArchetypes < ActiveRecord::Migration
  def self.up
    create_table :archetypes do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :archetypes
  end
end
