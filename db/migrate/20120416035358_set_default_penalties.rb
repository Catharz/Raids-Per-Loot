class SetDefaultPenalties < ActiveRecord::Migration
  def up
    CharacterType.reset_column_information
    CharacterType.all.each do |char_type|
      char_type.normal_penalty = 0
      char_type.progression_penalty = 0
      char_type.save!
    end
  end

  def down
  end
end
