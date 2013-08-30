# @author Craig Read
#
# LinkCategoriesLink resolves the many-to-many relationship
# between a Link Category and its Links
class LinkCategoriesLink < ActiveRecord::Base
  belongs_to :link, :inverse_of => :link_categories_links, :touch => true
  belongs_to :link_category, :inverse_of => :link_categories_links, :touch => true
end