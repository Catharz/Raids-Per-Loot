class AddDifficultyToMobs < ActiveRecord::Migration
  def change
    add_column :mobs, :difficulty_id, :integer, :references => :difficulties
  end
end
