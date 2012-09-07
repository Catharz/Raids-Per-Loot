class CachePageChildrenCount < ActiveRecord::Migration
  def up
    execute "update pages set children_count = (select count(*) from pages p2 where p2.parent_id = pages.id)"
  end

  def down
  end
end
