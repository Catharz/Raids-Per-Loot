class UpdateMissingPlayerRanks < ActiveRecord::Migration
  def up
    unknown_rank = Rank.find_or_create_by_name("Unknown")
    unless unknown_rank.nil?
      Player.where("rank_id is null").each do |player|
        player.rank_id = unknown_rank.id
        player.save!
      end
    end
  end

  def down
  end
end
