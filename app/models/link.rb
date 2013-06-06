class Link < ActiveRecord::Base
  has_many :link_categories_links, :inverse_of => :link
  has_many :link_categories, :through => :link_categories_links, :inverse_of => :links

  validates_presence_of :title
  accepts_nested_attributes_for :link_categories
end
