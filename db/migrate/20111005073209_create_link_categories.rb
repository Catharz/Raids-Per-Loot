class CreateLinkCategories < ActiveRecord::Migration
  def self.up
    create_table :link_categories do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :link_categories
  end
end
