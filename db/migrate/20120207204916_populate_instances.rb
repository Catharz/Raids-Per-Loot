class PopulateInstances < ActiveRecord::Migration
  def self.up
    Raid.all.each do |raid|
      instance = Instance.create(:zone => raid.zone,
                                 :start_time => raid.start_time,
                                 :end_time => raid.end_time)

      Drop.find_all_by_raid_id(raid.id).each do |drop|
        drop.instance_id = instance.id
        drop.save
      end
      raid.players.each { |player| instance.players << player }
      instance.save
    end
  end

  def self.down
    Instance.delete_all
    Drop.each.all do |drop|
      drop.instance_id = nil
      drop.save
    end
  end
end
