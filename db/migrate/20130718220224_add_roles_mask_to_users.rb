class AddRolesMaskToUsers < ActiveRecord::Migration
  def change
    # Binary value to create M-M relationship within the table
    # Values are admin raid_leader officer raider guest
    # which makes guest = 16
    add_column :users, :roles_mask, :integer, default: 16
  end
end
