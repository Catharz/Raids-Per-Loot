class Character < ActiveRecord::Base
  include PointsCalculator

  belongs_to :player, :inverse_of => :characters, :touch => true
  belongs_to :archetype, :inverse_of => :characters, :touch => true

  has_many :drops, :inverse_of => :character
  has_many :character_instances, :inverse_of => :character
  has_many :character_types, :inverse_of => :character, :dependent => :destroy

  has_many :items, :through => :drops, :conditions => ["loot_method = ?", "n"]
  has_many :instances, :through => :character_instances
  has_many :raids, :through => :instances, :uniq => true

  has_many :adjustments, :as => :adjustable

  has_one :main_character, :through => :player

  validates_presence_of :player, :name, :char_type
  validates_uniqueness_of :name
  validates_format_of :char_type, :with => /g|m|r/ # General Alt, Main, Raid Alt

  has_one :last_switch, :class_name => 'CharacterType', :order => 'effective_date desc'

  def archetype_root
    if archetype
      archetype.root ? archetype.root.name : "Unknown"
    else
      "Unknown"
    end
  end

  def soe_data(server_name = "Unrest")
    @soe_data ||= SOEData.get("/json/get/eq2/character/?name.first=#{name}&locationdata.world=#{server_name}&c:limit=500&c:show=name.first,name.last,quests.complete,collections.complete,level,alternateadvancements.spentpoints,alternateadvancements.availablepoints,resists,skills,spell_list,stats,guild.name,type")
  end

  def fetch_soe_character_details(server_name = "Unrest")
    json_data = soe_data(server_name)
    character_details = json_data ? json_data['character_list'][0] : nil

    if character_details
      unless archetype and archetype.name.eql? character_details['type']['class']
        update_attribute(:archetype, Archetype.find_by_name(character_details['type']['class']))
      end
      true
    else
      false
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