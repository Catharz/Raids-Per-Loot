class RemoveUnnecessaryUsersColumns < ActiveRecord::Migration
  def up
    remove_columns :users,
                   :login, :crypted_password, :salt,
                   :remember_token, :remember_token_expires_at,
                   :activated_at, :activation_code
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the data in the deleted users columns"
  end
end
