class AddAdminPageAttributeToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :admin, :boolean
  end

  def self.down
    remove_column :pages, :admin
  end
end
