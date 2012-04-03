class CopyPlayersToCharacters < ActiveRecord::Migration
  def up
    # Check to make sure all of the players are valid before we perform this migration
    main_rank_id = Rank.find_by_name('Main').id
    non_member_rank_id = Rank.find_by_name('Non-Member').id
    invalid_players = Player.where('main_character_id is null and rank_id not in (?, ?)', main_rank_id, non_member_rank_id)
    if invalid_players.count > 0
      invalid_player_names = []
      invalid_players.to_a.collect!{ |player| invalid_player_names << player.name unless invalid_player_names.include? player.name }
      raise "Cannot perform migration, the following alternate characters exist without a main character id! (#{invalid_players.uniq.join(", ")})"
    end

    Player.all.each do |player|
      if player.main_character_id.nil?
        Character.create(:player_id => player.id,
                         :name => player.name,
                         :rank_id => player.rank_id,
                         :archetype_id => player.archetype_id)
      else
        Character.create(:player_id => player.main_character_id,
                         :name => player.name,
                         :rank_id => player.rank_id,
                         :archetype_id => player.archetype_id)
      end
    end
  end

  def down
    Character.delete_all
  end
end
