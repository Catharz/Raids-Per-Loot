module AttendanceSpecHelper
  def setup_raids(attendance)
    attendees = attendance[:attendees]
    num_raids = attendance[:num_raids]
    num_instances = attendance[:num_instances]

    zone_list = []
    zones = (1..num_instances).to_a
    zones.each do |zone_num|
      zone_list << stub_model(Zone, :name => "Zone #{zone_num.to_s}")
    end
    assign(:zones, zone_list)

    raid_list = []
    raids = (1..num_raids).to_a
    raids.each do |n|
      raid_list << stub_model(Raid, :raid_date => Date.today - num_raids.days + n.days)
    end
    assign(:raids, raid_list)

    instance_list = []
    raid_list.each do |raid|
      instances = (1..num_instances).to_a
      instances.each do |n|
        instance = stub_model(Instance,
                              :raid => raid,
                              :zone => zone_list[n - 1],
                              :start_time => raid.raid_date + n.hours,
                              :end_time => raid.raid_date + (n + 1).hours,)
        instance_list << instance
        raid.instances << instance
      end
    end
    attendees.each do |character|
      character.stub(:instances).and_return(instance_list)
      character.stub(:raids).and_return(raid_list)
      character.stub(:adjustments).and_return([])
      character.stub(:character_types).and_return([])
    end
    assign(:instances, instance_list)
  end
end