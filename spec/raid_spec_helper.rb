module RaidSpecHelper
  def create_raids(num_raids)
    raids = (1..num_raids).to_a
    raids.each do |n|
      Raid.create(:raid_date => Date.today - num_raids.days + n.days)
    end
    Raid.all
  end
end