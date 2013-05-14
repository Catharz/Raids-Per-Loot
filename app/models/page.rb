class Page < ActiveRecord::Base
  acts_as_tree :order => "navlabel", counter_cache: true
  acts_as_textiled :body

  validates_presence_of :name, :title, :navlabel, :body
  validates_uniqueness_of :name
  after_commit :invalidate_page_cache

  delegate :navlabel, to: :parent, prefix: :parent, allow_nil: true

  scope :find_main, -> {
    where(parent_id: nil).order(:position)
  }
  scope :find_main_public, -> {
    where(parent_id: nil, admin: false).order(:position)
  }

  def is_admin?
    admin? ? 'Yes' : 'No'
  end

  def redirection
    redirect ? "#{controller_name}/#{action_name}" : 'None'
  end

  def invalidate_page_cache
    Page.all.each { |page| page.touch unless page.eql? self }
  end
end
