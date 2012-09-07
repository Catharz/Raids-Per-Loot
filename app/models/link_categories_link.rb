class LinkCategoriesLink < ActiveRecord::Base
  belongs_to :link, :inverse_of => :link_categories_links, :touch => true
  belongs_to :link_category, :inverse_of => :link_categories_links, :touch => true
end