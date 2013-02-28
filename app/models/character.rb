require 'csv'

class Character < ActiveRecord::Base
  include RemoteConnectionHelper, PointsCalculationHelper, CharactersHelper

  belongs_to :player, :inverse_of => :characters, :touch => true
  belongs_to :archetype, :inverse_of => :characters, :touch => true

  has_many :drops, :inverse_of => :character
  has_many :character_instances, :inverse_of => :character
  has_many :character_types, :inverse_of => :character, :dependent => :destroy

  has_one :last_switch, :class_name => 'CharacterType', :order => 'updated_at desc'

  has_many :items, :through => :drops, :conditions => ["drops.loot_method = ?", "n"]
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :instances, :uniq => true

  has_many :adjustments, :as => :adjustable, :dependent => :destroy
  has_one :external_data, :as => :retrievable, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :player, :archetype, :char_type, :on => :update

  validates_uniqueness_of :name
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt

  def player_name
    player ? player.name : 'Unknown'
  end

  def main_character(at_time = nil)
    if player
      player.main_character(at_time)
    else
      char_type == 'm' ? self : nil
    end
  end

  def raid_alternate(at_time = nil)
    if player
      player.raid_alternate(at_time)
    else
      char_type == 'r' ? self : nil
    end
  end

  def general_alternates(at_time = nil)
    if player
      player.general_alternates(at_time)
    else
      char_type == 'g' ? [self] : []
    end
  end

  def archetype_name
    archetype ? archetype.name : "Unknown"
  end

  def archetype_root
    if archetype
      archetype.root ? archetype.root.name : "Unknown"
    else
      "Unknown"
    end
  end

  def soe_data(format = "json")
    #TODO: Refactor this out and get it into a central class or gem for dealing with Sony Data
    @soe_data ||= SOEData.get("/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/character/?name.first=#{name}&locationdata.world=#{APP_CONFIG["eq2_server"]}&c:limit=500&c:show=name.first,name.last,quests.complete,collections.complete,level,alternateadvancements.spentpoints,alternateadvancements.availablepoints,type,resists,skills,spell_list,stats,guild.name")
  end

  def combat_stats(format = "json")
    @stats ||= SOEData.get("/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/character/?name.first=#{name}&locationdata.world=#{APP_CONFIG["eq2_server"]}&c:limit=500&c:show=name,stats,type,alternateadvancements.spentpoints,alternateadvancements.availablepoints")
  end

  def fetch_soe_character_details
    #TODO: Refactor this out and get it into a central class or gem for dealing with Sony Data
    if internet_connection?
      json_data = soe_data("json")
      character_details = json_data ? json_data['character_list'][0] : HashWithIndifferentAccess.new

      if character_details.nil? or character_details.empty?
        false
      else
        unless archetype and archetype.name.eql? character_details['type']['class']
          update_attribute(:archetype, Archetype.find_by_name(character_details['type']['class']))
        end
        build_external_data(:data => character_details)
        external_data.save
        true
      end
    else
      true
    end
  end

  def self.soe_characters_with_stats(format = "json")
    url = "/s:#{APP_CONFIG["soe_query_id"]}/#{format}/get/eq2/guild/?c:limit=1&name=#{APP_CONFIG["guild_name"]}&world=#{APP_CONFIG["eq2_server"]}&c:resolve=members(type,stats,alternateadvancements.spentpoints,alternateadvancements.availablepoints,type,equipmentslot_list.item.id,equipmentslot_list.item.adornment_list)".gsub(" ", "%20")
    @guild = SOEData.get(url)
    @guild["guild_list"].empty? ? [] : @guild["guild_list"][0]["member_list"]
  end

  def self.by_name(name)
    name ? where(:name => name) : scoped
  end

  def self.by_instance(instance_id)
    instance_id ? includes(:character_instances).where('character_instances.instance_id = ?', instance_id) : scoped
  end

  def self.by_player(player_id)
    player_id ? where(:player_id => player_id) : scoped
  end

  def self.find_by_archetype(archetype)
    all_characters = Array.new
    Archetype.family(archetype).each do |child_archetype|
      all_characters << Character.all(:conditions => ['archetype_id = ?', child_archetype.id], :order => :name).flatten
    end
    all_characters.flatten.uniq
  end

  def rank_at_time(time)
    character_types.where('character_types.effective_date <= ?', time).order(:effective_date).last.char_type
  end

  def to_csv
    CSV.generate_line(
        [self.name,
         char_type_name(self.char_type),
         self.main_character ? self.main_character.name : "Unknown",
         self.archetype ? self.archetype.name : "Unknown",
         self.first_raid ? self.first_raid.raid_date : "Never",
         self.last_raid ? self.last_raid.raid_date : "Never",
         self.raids_count,
         self.instances_count,
         self.armour_rate,
         self.jewellery_rate,
         self.weapon_rate
        ])
  end
end