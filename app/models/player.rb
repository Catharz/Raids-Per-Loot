class Player < ActiveRecord::Base
  has_many :alternates, :class_name => 'Player', :foreign_key => 'main_character_id'
  belongs_to :main_character, :class_name => 'Player', :foreign_key => 'main_character_id'
  belongs_to :archetype
  belongs_to :rank

  #TODO Refactor to have a player linking to character(s) of different ranks

  has_and_belongs_to_many :instances
  has_many :drops

  validates_presence_of :name
  validates_uniqueness_of :name

  def loot_rate(loot_type)
    num_drops = 0
    drops.each do |drop|
      if drop.loot_type_name && (drop.loot_type_name.eql? loot_type)
        num_drops += 1
      end
    end
    instances.count / (num_drops + 1)
  end

  def calculate_loot_rate(event_count, item_count)
    event_count / (item_count + 1)
  end

  def self.find_by_archetype(archetype)
    all_players = Array.new
    Archetype.family(archetype).each do |child_archetype|
      all_players << Player.all(:conditions => ['archetype_id = ?', child_archetype.id], :order => :name).flatten
    end
    all_players.collect
    return all_players.flatten.uniq
  end

  def self.find_main_characters
    Player.find_by_main_character_id(nil, :order => 'name')
  end

  def to_xml(options = {})
    to_xml_opts = {}
    # a builder instance is provided when to_xml is called on a collection of instructors,
    # in which case you would not want to have <?xml ...?> added to each item
    to_xml_opts.merge!(options.slice(:builder, :skip_instruct))
    to_xml_opts[:root] ||= "player"
    self.attributes.to_xml(to_xml_opts)
  end
end