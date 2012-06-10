module RaidSpecHelper
  def create_raids(num_raids)
    raid_list = []
    raids = (1..num_raids).to_a
    raids.each do |n|
      raid_list << mock_model(Raid, :raid_date => Date.today - num_raids.days + n.days)
    end
    raid_list
  end

  def create_raid
    create_raids(1)[0]
  end
end