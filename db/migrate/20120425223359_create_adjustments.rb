class CreateAdjustments < ActiveRecord::Migration
  def change
    create_table :adjustments do |t|
      t.datetime :adjustment_date
      t.string :adjustment_type
      t.integer :amount
      t.string :reason
      t.integer :loot_type_id
      t.integer :adjustable_id
      t.string :adjustable_type

      t.timestamps
    end
  end
end
