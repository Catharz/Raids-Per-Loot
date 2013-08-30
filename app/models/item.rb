# @author Craig Read
#
# Item represents an in-game item to be looted
# on raids
class Item < ActiveRecord::Base
  include RemoteConnectionHelper, ArchetypesHelper

  belongs_to :loot_type, :inverse_of => :items
  has_many :drops, :inverse_of => :item

  has_many :items_slots
  has_many :slots, :through => :items_slots

  has_many :archetypes_items
  has_many :archetypes, :through => :archetypes_items

  has_one :external_data, :as => :retrievable, :dependent => :destroy

  has_one :last_drop, :class_name => 'Drop', :order => 'created_at desc'

  validates_presence_of :name, :eq2_item_id
  validates_uniqueness_of :eq2_item_id, :scope => :name

  delegate :name, to: :loot_type, prefix: :loot_type, allow_nil: true

  scope :of_type, ->(loot_type_name) {
    loot_type_name ? includes(:loot_type).where('loot_types.name = ?', loot_type_name) : scoped
  }
  scope :by_loot_type, ->(loot_type_id) {
    loot_type_id ? where('items.loot_type_id = ?', loot_type_id) : scoped
  }
  scope :by_name, ->(name) {
    name ? where(:name => name) : scoped
  }
  scope :by_eq2_item_id, ->(eq2_item_id) {
    eq2_item_id ? where(:eq2_item_id => eq2_item_id) : scoped
  }

  def class_names
    consolidate_archetypes(archetypes)
  end

  def slot_names
    if slots.empty?
      'None'
    else
      (slots.map {|a| a.name}).join(", ")
    end
  end

  def eq2wire_data
    Scraper.get("http://u.eq2wire.com/item/index/#{eq2_item_id}", '.itemd_detailwrap') if internet_connection?
  end
end
