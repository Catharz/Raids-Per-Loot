# @author Craig Read
#
# Link represents a link to an external site
class Link < ActiveRecord::Base
  has_many :link_categories_links, :inverse_of => :link
  has_many :link_categories, :through => :link_categories_links, :inverse_of => :links

  validates_presence_of :url, :title, :description
end
