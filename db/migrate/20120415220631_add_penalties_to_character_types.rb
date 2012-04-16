class AddPenaltiesToCharacterTypes < ActiveRecord::Migration
  def change
    add_column :character_types, :normal_penalty, :integer
    add_column :character_types, :progression_penalty, :integer
  end
end
