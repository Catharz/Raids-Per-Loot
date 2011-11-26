class LinkCategoriesJoin < ActiveRecord::Migration
  def self.up
    create_table :link_categories_links, :id => false do |t|
      t.integer :link_category_id
      t.integer :link_id
    end
  end

  def self.down
    drop_table :link_categories_links

  end
end
