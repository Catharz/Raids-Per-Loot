class AddSwitchRateToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :switch_count, :integer
    add_column :players, :switch_rate, :number
  end
end
