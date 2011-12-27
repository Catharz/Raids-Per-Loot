class RenameDropsItemUrlColumn < ActiveRecord::Migration
  def self.up
    rename_column :drops, :item_url, :info_url
  end

  def self.down
    rename_column :drops, :info_url, :item_url
  end
end
