class Page < ActiveRecord::Base
  acts_as_textiled :body
  validates_presence_of :name, :title, :navlabel, :body
  has_many :subpages, :class_name => 'Page', :foreign_key => 'parent_id'
  belongs_to :parent, :class_name => 'Page', :foreign_key => 'parent_id'

  def self.find_main
    Page.find_all_by_parent_id(nil, :order => 'position')
  end

  def self.find_main_public
    Page.find_all_by_parent_id(nil, :conditions => ["admin != ?", true], :order => 'position')
  end
end
