class AddRankToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :rank_id, :integer
  end

  def self.down
    remove_column :players, :rank_id
  end
end
