module InstanceSpecHelper
  def create_instances(raid_list, zone_list)
    raid_list.each do |raid|
      instance_start = raid.raid_date + 18.hours
      zone_list.each do |zone|
        instance = Instance.find_by_raid_id_and_start_time(raid.id, instance_start)
        instance ||= Instance.create(:raid_id => raid.id,
                                     :zone_id => zone.id,
                                     :start_time => instance_start,
                                     :end_time => instance_start + 1.hour)
        instance_start = instance.end_time
      end
    end
    Instance.all
  end
end