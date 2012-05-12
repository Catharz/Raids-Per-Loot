class ConvertAdjustmentDateToDate < ActiveRecord::Migration
  def up
    change_table :adjustments do |t|
      t.change :adjustment_date, :date
    end
  end

  def down
    change_table :adjustments do |t|
      t.change :adjustment_date, :datetime
    end
  end
end
