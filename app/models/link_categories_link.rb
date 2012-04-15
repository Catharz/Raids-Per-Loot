class LinkCategoriesLink < ActiveRecord::Base
  belongs_to :link, :inverse_of => :link
  belongs_to :link_category, :inverse_of => :link_category
end