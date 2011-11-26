class AddActivationCodeToUsersTable < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_code, :string, :limit => 40
  end

  def self.down
    remove_column :users, :activation_code
  end
end
