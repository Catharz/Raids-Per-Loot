class ArchetypesHierarchy < ActiveRecord::Migration
  def self.up
		add_column :archetypes, :parent_class, :integer
  end

  def self.down
		remove_column :archetypes, :parent_class, :integer
  end
end
