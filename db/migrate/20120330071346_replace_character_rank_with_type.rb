class ReplaceCharacterRankWithType < ActiveRecord::Migration
  def up
    add_column :characters, :char_type, :string, :length => 1, :null => false, :default => 'm'
    Character.reset_column_information
    Character.all.each do |character|
      case character.rank_id
        when Rank.find_by_name('Raid Alternate').id
          character.char_type = 'r'
        when Rank.find_by_name('General Alternate').id
          character.char_type = 'g'
        else
          character.char_type = 'm'
      end
      character.save!
    end
    remove_column :characters, :rank_id
  end

  def down
    add_column :characters, :rank_id, :integer
    Character.reset_column_information
    Character.all.each do |character|
      case character.char_type
        when 'r'
          character.rank = Rank.find_by_name('Raid Alternate')
        when 'g'
          character.rank = Rank.find_by_name('General Alternate')
        else
          character.rank = character.player.rank
      end
      character.save!
    end
    remove_column :characters, :char_type
  end
end
