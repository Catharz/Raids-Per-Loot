class AddSwitchRateToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :switches_count, :integer, default: 0
    add_column :players, :switch_rate, :float, default: 0.0
  end
end
