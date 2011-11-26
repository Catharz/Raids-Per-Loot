class AddAdminPageAttributeToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :admin, :boolean

    @pages = Page.all
    @pages.each do |page|
      page.update_attribute(:admin, false)
    end
  end

  def self.down
    remove_column :pages, :admin
  end
end
