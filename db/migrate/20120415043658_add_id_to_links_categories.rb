class AddIdToLinksCategories < ActiveRecord::Migration
  def change
    change_table :link_categories_links do |t|
      t.column :id, :primary_key, :before => :link_id
      t.timestamps
    end
  end
end
