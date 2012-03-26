class AddDifficultyToZones < ActiveRecord::Migration
  def change
    add_column :zones, :difficulty_id, :integer, :references => :difficulties
  end
end
