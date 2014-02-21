# @author Craig Read
#
# Eq2LogParser parses a given file, returning a hash
# containing raids, instances, attendees and drops
class Eq2LogParser
  extend Memoist

  attr_reader :raid_list

  CHARACTER_REGEXP = [
      /] \\aPC -1 (?<character>\w+):(?<name>\w+)\\\/a says to the raid party, \"(?<text>.*)\"$/,
      /] (?<healer>\w+)('s|'|) (?<spell>.*)(| critically) (heals|heal) (?<character>\w+) for (?<health>\d+) hit points/,
      /] (?<caster>\w+)('s|'|) (?<spell>.*)(| critically) (hit|multi attack)(|s) (?<target>.*) for (?<health>\d+) (?<damage_type>\w+) damage/,
      /] (?<damager>\w+)('s|'|)(| critically) (multi attack|hit)(|s) (?<target>.*) for (?<damage>\d+) (?<damage_type>\w+) damage/,
      /] (?<attacker>.*) tries to (?<method>\w+) (?<character>\w+), but (?<failure>\w+)/,
      /] (?<attacker>.*) (hits|multi attacks) (?<character>\w+) but fails to inflict any damage./,
      /] (?<attacker>.*) tries to (?<method>\w+) (?<character>\w+) with (?<spell>.*), but (?<character_2>\w+) resist(|s)./
  ]

  def initialize(file_name)
    @file_name = file_name
    @file = File.open(file_name)
    @raid_list = {}
  end

  def parse
    parse_raids
    parse_zones
    populate_instances
    cleanup_instances
  end

  def parse_raids
    zone_entrances.each do |line|
      match = zone_match(line)
      raid_date = Date.parse(match[:log_date])
      @raid_list[raid_date] ||= {instances: []}
    end
    @raid_list
  end

  def parse_zones
    Rails.logger.info "Parsing zones in #{@file_name}"
    zone_entrances.each { |line| record_zone_entry(zone_entry_details(line)) }
  end

  def zone_entrances
    @file.grep(/You have entered/)
  end

  def file_owner
    file_info = @file_name.match(/.*eq2log_(?<owner>\w+)\.*/)
    file_info.nil? ? nil : file_info['owner']
  end

  def zone_match(line)
    line.match(/\((?<log_line_id>\d+)\)\[(?<log_date>.*)\] You have entered (?<zone_name>.*)\./)
  end

  def populate_instances
    ignored, processed = 0, 0
    Rails.logger.debug "Parsing instances in #{@file_name}"
    @raid_list.each_pair do |raid_date, raid|
      raid[:instances].each do |instance|
        if zone_names.include? instance[:zone_name]
          processed += 1
          Rails.logger.info "Getting stats for #{instance[:zone_name]} raid on #{raid_date}"
          instance[:drops] = drops(instance[:start_line], instance[:end_line])
          instance[:attendees] = attendees(instance[:start_line], instance[:end_line])
          Rails.logger.info "Found #{instance[:attendees].count} attendees and #{instance[:drops].count} drops"
        else
          ignored += 1
        end
      end
    end
    Rails.logger.info "Found #{processed} raid instances and #{ignored} non-raid instances"
  end

  def drops(start_line, end_line)
    @file.rewind
    drop_regex = /\((?<log_line_id>\d+)\)\[(?<log_date>.*)\] (?<looter>\w+) (loot|loots) \\aITEM (?<item_id>-?\d+) -?\d+:(?<item_name>[^\\]+)\\\/a from (?<container>.+) of (?<mob_name>.+)\./
    drops = @file.grep(drop_regex).collect! { |d| drop_match_to_hash(d.match(drop_regex)) }
    drops.delete_if { |d| (d[:log_line_id].to_i < start_line) or (d[:log_line_id].to_i > end_line) }
    drops.collect { |d| d[:chat] = prior_chat Time.zone.parse(d[:log_date]) }
    drops.sort { |a, b| DateTime.parse(a[:log_date]) <=> DateTime.parse(b[:log_date]) }
  end

  def prior_chat(end_time, options = {max_lines: 20, max_time: 60.seconds})
    chat = []
    chat_match = /\((?<log_line_id>\d+)\)\[(?<log_date>.*)\] \\aPC -1 (?<character>\w+):.+\\\/a says to the (raid|guild|officers)/
    rand_match = /\((?<log_line_id>\d+)\)\[(?<log_date>.*)\] Random: (?<character>\w+) rolls from 1 to (?<max>\d+)/
    @file.rewind
    @file.grep(/says to the (guild|raid|officers)|Random:/).each do |line|
      match = line.match chat_match
      match ||= line.match rand_match
      next if match.nil?
      next if Time.zone.parse(match[:log_date]) < (end_time - options[:max_time])
      break if Time.zone.parse(match[:log_date]) > end_time
      chat << line.strip
    end
    chat.last(options[:max_lines]).join("\n")
  end

  def attendees(start_line, end_line)
    line_regex = /\((?<log_line_id>\d+)\)\[(?<log_date>.*)\]/
    characters = []
    @file.rewind
    @file.each do |line|
      line_match = line.match(line_regex)
      next if line_match.nil?
      next if line_match[:log_line_id].to_i < start_line
      break if line_match[:log_line_id].to_i > end_line
      info = character_info(line)
      extract_names(characters, info) unless info.nil?
    end
    Rails.logger.debug "Attendees: #{characters.uniq.sort.join ' '}"
    Rails.logger.info "#{characters.uniq.count} characters attended."
    characters.uniq.sort
  end

  def extract_names(characters, info)
    info.names.each do |field|
      if %w{character healer caster damager target}.include? field
        name = real_name(info[field.to_sym])
        characters << name if character_names.include? name
      end
    end
  end

  def mobs(start_line, end_line)
    drops(start_line, end_line).collect! { |d| d[:mob_name] }
  end

  def zone_names
    Zone.select(:name).order(:name).map! { |z| z.name }
  end

  def character_names
    Character.select(:name).order(:name).map! { |c| c.name }
  end

  def real_name(name)
    return file_owner if %w{YOUR YOU}.include? name.upcase
    name
  end

  private
  def record_zone_entry(entry_details)
    Rails.logger.debug "Entered #{entry_details[:zone_name]} at #{entry_details[:entry_time]}"
    raid_details = @raid_list[entry_details[:raid_date]]
    if raid_details[:instances].empty?
      raid_details[:instances] << entry_details
    else
      last_instance = raid_details[:instances].last
      unless last_instance[:zone_name].eql? entry_details[:zone_name]
        last_instance[:exit_time] = entry_details[:entry_time]
        last_instance[:end_line] = entry_details[:start_line]
        raid_details[:instances] << entry_details
      end
    end
  end

  def character_info(line)
    info = nil
    CHARACTER_REGEXP.each do |regexp|
      info = line.match(regexp)
      break unless info.nil?
    end
    info
  end

  def zone_entry_details(log_line)
    match = zone_match(log_line)
    {
        raid_date: Date.parse(match[:log_date]),
        zone_name: match[:zone_name],
        entry_time: Time.zone.parse(match[:log_date]),
        exit_time: Time.zone.parse(match[:log_date]).midnight,
        start_line: match[:log_line_id].to_i,
        end_line: 0
    }
  end

  def cleanup_instances
    Rails.logger.debug "Cleaning up data parsed from #{@file_name}"
    @raid_list.each_pair do |raid_date, raid|
      raid[:instances].delete_if { |i|
        i[:end_line] == 0 or
            !zone_names.include? i[:zone_name] or
            i[:attendees].count < 2
      }
    end
    @raid_list.delete_if { |raid_date| @raid_list[raid_date][:instances].empty? }
  end

  def drop_match_to_hash(match_data)
    {
      log_line_id: match_data[:log_line_id],
      log_date: match_data[:log_date],
      looter: match_data[:looter],
      item_id: match_data[:item_id],
      item_name: match_data[:item_name],
      container: match_data[:container],
      mob_name: match_data[:mob_name],
      log_line: match_data.string
    }
  end

  memoize :drops, :zone_entrances, :file_owner, :zone_match, :zone_names, :character_names
end
