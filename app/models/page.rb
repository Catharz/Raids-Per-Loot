class Page < ActiveRecord::Base
  acts_as_tree :order => "navlabel"
  acts_as_textiled :body
  validates_presence_of :name, :title, :navlabel, :body
  validates_uniqueness_of :name

  def self.find_main
    Page.where(:parent_id => nil).order(:position)
  end

  def self.find_main_public
    Page.where(:parent_id => nil).where('admin = ?', false).order(:position)
  end
end
