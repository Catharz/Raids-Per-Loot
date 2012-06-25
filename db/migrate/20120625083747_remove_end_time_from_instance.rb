class RemoveEndTimeFromInstance < ActiveRecord::Migration
  def up
    remove_column :instances, :end_time
  end

  def down
    add_column :instances, :end_time, :datetime
  end
end
