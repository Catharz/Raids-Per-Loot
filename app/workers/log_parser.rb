# @author Craig Read
#
# LogParser parses a file from the temp directory
class LogParser
  @queue = :log_parser

  def self.perform(file_name)
    start_time = Time.zone.now
    Rails.logger.info "Starting background parsing of #{file_name} at #{start_time.to_s}"
    @parser = Eq2LogParser.new(file_name)
    @parser.parse
    @normal_raid = RaidType.find_by_name('Normal')
    save_raids @parser.raid_list unless @parser.raid_list.empty?
    end_time = Time.zone.now
    Rails.logger.info "Completed background parsing of #{file_name} at #{end_time.to_s}, total duration: #{(end_time - start_time).to_s}"
  end

  private
  def self.save_raids(raid_list)
    raid_list.each_pair do |raid_date, raid_details|
      raid = Raid.find_by_raid_date(raid_date)
      raid ||= Raid.create(raid_date: raid_date, raid_type: @normal_raid)
      save_instances(raid, raid_details[:instances])
    end
  end

  def self.save_instances(raid, instance_list)
    instance_list.each do |instance_details|
      instance = Instance.find_or_create_by_start_time(instance_details[:entry_time])
      unless instance.persisted?
        instance.raid = raid
        instance.zone = Zone.find_by_name(instance_details[:zone_name])
        instance.save
        save_attendees(instance, instance_details[:attendees])
        save_loot(instance, instance_details[:drops])
      end
    end
  end

  def self.save_attendees(instance, attendees)
    attendees.each do |name|
      character = Character.find_by_name(name)
      unless CharacterInstance.exists?(character: character, instance: instance)
        CharacterInstance.create(character: character, instance: instance)
      end
      unless PlayerRaid.exists?(player: character.player, raid: instance.raid)
        PlayerRaid.create(player: character.player, raid: instance.raid)
      end
    end
  end

  def self.save_loot(instance, drops)
    unknown = loot_type_by_name 'Unknown'
    drops.each do |drop|
      item = Item.find_by_eq2_item_id_and_name(drop[:item_id], drop[:item_name])
      item ||= Item.create(name: drop[:item_name], eq2_item_id: drop[:item_id], loot_type: unknown)
      unless Drop.exists?(drop_time: Time.zone.parse(drop[:log_date]), item_id: item.id)
        save_drop(instance, item, drop)
      end
    end
  end

  def self.save_drop(instance, item, drop_details)
    character = Character.find_by_name(@parser.real_name(drop_details[:looter]))
    mob = Mob.find_or_create_by_name_and_zone_id(drop_details[:mob_name], instance.zone_id)
    Drop.create(drop_time: Time.zone.parse(drop_details[:log_date]),
                instance: instance,
                zone: instance.zone,
                mob: mob,
                character: character,
                item: item,
                loot_type: item.loot_type,
                loot_method: item.loot_type.default_loot_method,
                chat: drop_details[:chat],
                log_line: drop_details[:log_line])
  end

  def self.loot_type_by_name(name)
    @loot_types ||= {}
    @loot_types[name] ||= LootType.find_by_name(name)
  end
end
