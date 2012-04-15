class AddIdToArchetypesItems < ActiveRecord::Migration
  def change
    change_table :archetypes_items do |t|
      t.column :id, :primary_key, :before => :archetype_id
      t.timestamps
    end
  end
end
