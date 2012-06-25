module InstanceSpecHelper
  def create_instances(raid_list, zone_list)
    instance_list = []
    raid_list.each do |raid|
      instance_start = raid.raid_date + 18.hours
      zone_list.each do |zone|
        instance = mock_model(Instance, :raid_id => raid.id,
                              :zone_id => zone.id,
                              :start_time => instance_start)
        instance.stub!(:zone).and_return(zone)
        instance_list << instance
      end
    end
    instance_list
  end
end