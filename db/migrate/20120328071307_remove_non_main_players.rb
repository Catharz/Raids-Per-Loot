class RemoveNonMainPlayers < ActiveRecord::Migration
  def up
    main_rank_id = Rank.find_by_name('Main').id
    non_member_rank_id = Rank.find_by_name('Non-Member').id
    raise "'Main' rank name changed, cannot perform this migration!" unless main_rank_id
    raise "'Non-Member' rank name changed, cannot perform this migration!" unless non_member_rank_id

    Player.where('rank_id NOT IN (?, ?)', main_rank_id, non_member_rank_id).delete_all
  end

  def down
    main_rank_id = Rank.find_by_name('Main').id
    non_member_rank_id = Rank.find_by_name('Non-Member').id
    raise ActiveRecord::IrreversibleMigration, "'Main' rank name changed, cannot reverse migration!" unless main_rank_id
    raise ActiveRecord::IrreversibleMigration, "'Non-Member' rank name changed, cannot reverse migration!" unless non_member_rank_id

    Player.all.each do |player|
      player.characters.each do |character|
        unless character.rank_id.eql? main_rank_id or character.rank_id.eql? non_member_rank_id
          Player.create(:main_character_id => player.id,
                        :name => character.name,
                        :rank_id => character.rank_id,
                        :archetype_id => character.archetype_id)
        end
      end
    end
  end
end