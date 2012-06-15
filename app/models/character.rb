class Character < ActiveRecord::Base
  include RemoteConnectionHelper
  include PointsCalculator

  belongs_to :player, :inverse_of => :characters, :touch => true
  has_one :main_character, :through => :player

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

  validates_presence_of :player, :name, :char_type
  validates_uniqueness_of :name
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt

  def archetype_root
    if archetype
      archetype.root ? archetype.root.name : "Unknown"
    else
      "Unknown"
    end
  end

  def soe_data(server_name = "Unrest", format = "json")
    @soe_data ||= SOEData.get("/#{format}/get/eq2/character/?name.first=#{name}&locationdata.world=#{server_name}&c:limit=500&c:show=name.first,name.last,quests.complete,collections.complete,level,alternateadvancements.spentpoints,alternateadvancements.availablepoints,resists,skills,spell_list,stats,guild.name,type,equipmentslot_list")
  end

  def fetch_soe_character_details(server_name = "Unrest")
    if internet_connection?
      json_data = soe_data(server_name, "json")
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
end