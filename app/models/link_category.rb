class LinkCategory < ActiveRecord::Base
  has_many :link_categories_links, :inverse_of => :link_category
  has_many :links, :through => :link_categories_links, :inverse_of => :link_categories

  validates_presence_of :title
  validates_uniqueness_of :title
end
