class AddItemUrlToDrops < ActiveRecord::Migration
  def self.up
    add_column :drops, :item_url, :string
  end

  def self.down
    drop_column :drops, :item_url
  end
end
