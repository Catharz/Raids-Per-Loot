class Page < ActiveRecord::Base
  acts_as_tree :order => "navlabel", counter_cache: true
  acts_as_textiled :body

  validates_presence_of :name, :title, :navlabel, :body
  validates_uniqueness_of :name
  after_commit :invalidate_page_cache

  def parent_navlabel
    parent ? parent.navlabel : ""
  end

  def is_admin?
    admin? ? "Yes" : "No"
  end

  def redirection
    redirect ? "#{controller_name}/#{action_name}" : "None"
  end

  def self.find_main
    Page.where(:parent_id => nil).order(:position)
  end

  def self.find_main_public
    Page.where(:parent_id => nil).where(admin: false).order(:position)
  end

  def invalidate_page_cache
    Page.all.touch
  end
end
