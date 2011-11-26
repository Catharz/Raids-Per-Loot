class AddDefaultRanks < ActiveRecord::Migration
  def self.up
    if Rank.all.empty?
      Rank.create(:name => 'Main', :priority => 1)
      Rank.create(:name => 'Raid Alternate', :priority => 2)
      Rank.create(:name => 'General Alternate', :priority => 3)
    end
  end

  def self.down
    ['Main', 'Raid Alternate', 'General Alternate'].each do |rank|
      Rank.find_by_name!(rank).delete
    end
  end
end
